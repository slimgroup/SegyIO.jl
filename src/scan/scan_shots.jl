export scan_shots

function scan_shots!(s::IO, mem_chunk::Int, mem_trace::Int,
                    keys::Array{String,1}, file::String, scan::Array{BlockScan,1})

    # Load chunk into memory
    chunk_start = position(s)
    buf = IOBuffer(read(s, mem_chunk)) 
    buf_size = position(seekend(buf)); seekstart(buf)
    th_byte2sample = SeisIO.th_byte2sample()
    ntraces = Int(floor(buf_size/mem_trace))
    headers = Array{BinaryTraceHeader,1}(ntraces)

    # Get headers from chunk 
    for i in 1:ntraces
        headers[i] = read_traceheader(buf, keys, th_byte2sample)
        skip(buf, mem_trace-240)
    end 
    
    # Get all requested header vectors
    vals = Dict{String, Array{Int32,1}}()
    for k in keys
        tmp = Int32.([getfield((headers[i]), Symbol(k)) for i in 1:ntraces])
        vals["$k"] = tmp
    end # k

    # Deliminate to find shots
    sx = vals["SourceX"] 
    sy = vals["SourceY"] 
    combo = [[view(sx,i) view(sy,i)] for i in 1:ntraces]
    part = push!(delim_vector(combo,1), length(combo)+1)

    # Summarise each shot
    for shot in 1:length(part)-1
        start_trace = part[shot]
        end_trace = part[shot + 1]-1
        start_byte = mem_trace*(start_trace-1)
        end_byte = mem_trace*(end_trace-1)
        summary = Dict{String, Array{Int32,1}}()

        for k in keys
            tmp = vals[k][start_trace:end_trace]
            summary["$k"] = [minimum(tmp); maximum(tmp)]
        end
       
        push!(scan, BlockScan(file, start_byte, end_byte, summary))
    end
    close(buf)
    nothing
end
