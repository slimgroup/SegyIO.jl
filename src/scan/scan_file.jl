export scan_file

"""
    scan_file(file::String, keys::Array{String, 1}, blocksize::Int;
              chunksize::Int = CHUNKSIZE,
              verbosity::Int = 1)

Scan `file` for header fields in `keys`, and return a SeisCon object containing
the metadata summaries in `blocksize` groups of traces. Load `chunksize` MB of `file`
into memory at a time.

If the number of traces in `file` are not divisible by `blocksize`, the last block will
summarize the remaining traces.

`verbosity` set to 0 silences updates on the current file being scanned.

# Example

    s = scan_file('testdata.segy', ["SourceX", "SourceY"], 300)
"""
function scan_file(file::AbstractString, keys::Array{String, 1}, blocksize::Int;
                   chunksize::Int = CHUNKSIZE,
                   verbosity::Int = 1)
    
    # Put fileheader in memory and read
    verbosity==1 && println("Scanning ... $file") 
    s = open(file)
    fh = read_fileheader(s)

    # Calc number of blocks
    fsize = position(seekend(s))
    mem_trace = 240 + fh.bfh.ns*4
    mem_block = min(fsize, blocksize*mem_trace)
    ntraces_file = Int((fsize - 3600)/mem_trace)
    nblocks_file = max(1, Int(ceil(ntraces_file/blocksize)))
    scan = Array{BlockScan,1}(undef, nblocks_file)
    count = 1

    # Blocks to load per chunk
    max_blocks_per_chunk = max(1, Int(floor(chunksize*MB2B/mem_block)))

    # Read at most one full chunk into buffer
    seek(s, 3600)

    # For each chunk
    for c in 1:max_blocks_per_chunk:nblocks_file
       
        count = scan_chunk!(s, max_blocks_per_chunk, mem_block, mem_trace,
                            keys, file, scan, count)

    end # c

    return SeisCon(fh.bfh.ns, fh.bfh.DataSampleFormat, scan)
        
end

"""
    scan_file(file::String, keys::Array{String, 1};
              chunksize::Int = CHUNKSIZE,
              verbosity::Int = 1)

Scan `file` for header fields in `keys`, and return a SeisCon object containing
the metadata summaries in single-source groups of traces. Load `chunksize` MB of `file`
into memory at a time.

# Example

    s = scan_file('testdata.segy', ["SourceX", "SourceY"])

"""
function scan_file(file::AbstractString, keys::Array{String, 1};
                   chunksize::Int = 10*CHUNKSIZE,
                   verbosity::Int = 1)

    # Put fileheader in memory and read
    verbosity==1 && println("Scanning ... $file")
    s = open(file)
    fh = read_fileheader(s)

    # Add src keys if necessary 
    "SourceX" in keys ? nothing : push!(keys, "SourceX")
    "SourceY" in keys ? nothing : push!(keys, "SourceY")

    # Calc number of blocks
    fsize = filesize(file)
    mem_trace = 240 + fh.bfh.ns*4
    scan = Array{BlockScan,1}(undef, 0)
    seek(s, 3600)

    ntraces = Int((fsize - 3600)/mem_trace)
    traces_per_chunk = min(ntraces, Int(floor(chunksize*MB2B/mem_trace)))

    mem_chunk = traces_per_chunk*mem_trace
    fl_eof = false
    while !eof(s)
        scan_shots!(s, mem_chunk, mem_trace, keys, file, scan, fl_eof)
    end
    
    close(s)
    return SeisCon(fh.bfh.ns, fh.bfh.DataSampleFormat, scan[1:end])
        
end
