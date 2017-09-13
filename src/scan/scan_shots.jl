export scan_shots

function scan_shots!(s::IO, mem_chunk::Int, mem_trace::Int,
                    keys::Array{String,1}, file::String, scan::Array{BlockScan,1}, fl_eof::Bool)

    # Load chunk into memory
    chunk_start = position(s)
    buf = IOBuffer(read(s, mem_chunk)) 
    eof(s) ? (fl_eof=true) : nothing
    buf_size = position(seekend(buf)); seekstart(buf)
    ntraces = Int(floor(buf_size/mem_trace))
    vals = Dict{String, Array{Int32,1}}()

    # Init empty arrays
    for k in keys
        vals["$k"] = Array{Int32,1}(ntraces)
    end # k

    for i in 1:ntraces
        read_traceheader!(buf,keys)
        for k in keys
            tmp = Int32(getfield((SeisIO.blank_th), Symbol(k)))
            vals["$k"][i] = tmp
        end # k

    end

    # Deliminate to find shots
    sx = vals["SourceX"] 
    sy = vals["SourceY"] 
    #combo = [[view(sx,i) view(sy,i)] for i in 1:ntraces]
    combo = [[sx[i] sy[i]] for i in 1:ntraces]
    part = delim_vector(combo,1)
    fl_eof ? push!(part, length(combo) + 1) : nothing

    # Summarise each shot
    for shot in 1:length(part)-1
        start_trace = part[shot]
        end_trace = part[shot + 1]-1
        start_byte = mem_trace*(start_trace-1) + chunk_start
        end_byte = mem_trace*(end_trace) + chunk_start
        summary = Dict{String, Array{Int32,1}}()

        for k in keys
            tmp = vals[k][start_trace:end_trace]
            summary["$k"] = [minimum(tmp); maximum(tmp)]
        end
       
        push!(scan, BlockScan(file, start_byte, end_byte, summary))
    end
    
    seek(s, scan[end].endbyte)
    close(buf)
    nothing
end
