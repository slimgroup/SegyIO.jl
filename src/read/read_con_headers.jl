export read_con_headers

"""
read_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Array{Int,1};
                                prealloc_traces::Int = 50000)

Read `keys` from `blocks` in `con`. Skips all data and only reads and returns headers.

# Examples

h = read_con_headers(s, ["SourceX"; "SourceY"], Array(1:11))
"""
function read_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Array{Int,1};
                                prealloc_traces::Int = 50000)
    nblocks = length(blocks)

    # Check dsf
    datatype = Float32
    if con.dsf == 1
        datatype = IBMFloat32
    elseif con.dsf != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end
    
    # Check for RecSrcScalar
    in("RecSourceScalar", keys) ? nothing : push!(keys, "RecSourceScalar")
    in("ElevationScalar", keys) ? nothing : push!(keys, "ElevationScalar")

    # Pre-allocate
    headers = zeros(BinaryTraceHeader, prealloc_traces)
    fh = FileHeader()
    set_fileheader!(fh.bfh, :ns, con.ns)
    set_fileheader!(fh.bfh, :DataSampleFormat, con.dsf)

    # Read all blocks
    trace_count = 0
    for block in blocks
        
        # Check size of next block and pass view to pre-alloc
        brange = con.blocks[block].endbyte - con.blocks[block].startbyte
        ntraces = Int((brange)/(240 + con.ns*4))

        # Check if there is room in pre-alloc'd mem
        isroom = (trace_count + ntraces) <= length(headers)
        if ~isroom
            println("Expanding preallocated memory")
            prealloc_traces *= 2
            prealloc_traces += ntraces
            prealloc_headers = zeros(BinaryTraceHeader, ntraces+prealloc_traces)
            append!(headers, prealloc_headers)
        end
        tmp_headers = view(headers, (trace_count+1):(trace_count+ntraces)) 

        # Read the next block
        read_block_headers!(con.blocks[block], keys, con.ns, con.dsf, tmp_headers)
        trace_count += ntraces
    end

    return SeisBlock{datatype}(fh, headers[1:trace_count], Array{datatype,2}(undef,0,0))
    
end

function read_con_headers(con::SeisCon, blocks::Array{Int,1};
                                prealloc_traces::Int = 50000)
    nblocks = length(blocks)

    # Check dsf
    datatype = Float32
    if con.dsf == 1
        datatype = IBMFloat32
    elseif con.dsf != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    # Pre-allocate
    headers = Array{BinaryTraceHeader,1}(undef, prealloc_traces) 
    fh = FileHeader(); set_fileheader!(fh.bfh, :ns, con.ns)
    set_fileheader!(fh.bfh, :DataSampleFormat, con.dsf)

    # Read all blocks
    trace_count = 0
    for block in blocks
        
        # Check size of next block and pass view to pre-alloc
        brange = con.blocks[block].endbyte - con.blocks[block].startbyte
        ntraces = Int((brange)/(240 + con.ns*4))

        # Check if there is room in pre-alloc'd mem
        isroom = (trace_count + ntraces) <= length(headers)
        if ~isroom
            println("Expanding preallocated memory")
            prealloc_traces *= 2
            prealloc_traces += ntraces
            append!(headers, Array{BinaryTraceHeader,1}(undef, ntraces+prealloc_traces))
        end
        tmp_headers = view(headers, (trace_count+1):(trace_count+ntraces)) 

        # Read the next block
        read_block_headers!(con.blocks[block], con.ns, con.dsf, tmp_headers)
        trace_count += ntraces
    end

    return SeisBlock{datatype}(fh, headers[1:trace_count], Array{datatype,2}(undef,0,0))
    
end

function read_con_headers(con::SeisCon, blocks::TR;
                          prealloc_traces::Int = 50000) where {TR<:AbstractRange}
    read_con_headers(con, Array(blocks), prealloc_traces = prealloc_traces)
end
function read_con_headers(con::SeisCon, blocks::Integer;
                                prealloc_traces::Int = 50000)
    read_con_headers(con, [blocks], prealloc_traces = prealloc_traces)
end
function read_con_headers(con::SeisCon, keys::Array{String,1}, blocks::TR;
                          prealloc_traces::Int = 50000) where {TR<:AbstractRange}
    read_con_headers(con, keys, Array(blocks), prealloc_traces = prealloc_traces)
end
function read_con_headers(con::SeisCon, keys::Array{String,1}, blocks::Integer;
                                prealloc_traces::Int = 50000)
    read_con_headers(con, keys, [blocks], prealloc_traces = prealloc_traces)
end
