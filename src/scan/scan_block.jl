export scan_block

function scan_block(buf::IO, mem_block::Int, mem_trace::Int, keys::Array{String,1},
                    chunk_start::Int, file::String, th_byte2sample::Dict{String, Int32})
    
    # Calc info about this block
    startbyte = position(buf) + chunk_start
    ntraces_block = Int(mem_block/mem_trace)
    println(ntraces_block)
    headers = Array{BinaryTraceHeader,1}(ntraces_block)
    
    # Read all headers and record end byte
    for t in 1:ntraces_block

        headers[t] = read_traceheader(buf, keys, th_byte2sample)
        skip(buf, mem_trace-240)

    end # t
    endbyte = position(buf) + chunk_start
    
    # Parse headers for min/max
    summary = Dict{String, Array{Int32,1}}()
    for k in keys
        tmp = Int32.([getfield((headers[i]), Symbol(k)) for i in 1:ntraces_block])
        summary["$k"] = [minimum(tmp); maximum(tmp)]
    end # k
    
    # Collect in BlockScan and return
    scan = BlockScan(file, startbyte, endbyte, summary) 

    return scan
end
