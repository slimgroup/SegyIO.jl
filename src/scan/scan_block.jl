export scan_block

function scan_block(buf::IO, mem_block::Int, mem_trace::Int, keys::Array{String,1},
                    chunk_start::Int, file::String, th_byte2sample::Dict{String, Int32})
    
    # Calc info about this block
    startbyte = position(buf) + chunk_start
    ntraces_block = Int(mem_block/mem_trace)
    headers = zeros(BinaryTraceHeader, ntraces_block)
    count = 0    

    # Read all headers and record end byte
    while !eof(buf) && count<ntraces_block
        count += 1
        read_traceheader!(buf, keys, th_byte2sample,  headers[count] )
        skip(buf, mem_trace-240)
    end 
    endbyte = position(buf) + chunk_start
    headers_block = view(headers,1:count)
    
    # Parse headers for min/max
    summary = Dict{String, Array{Int32,1}}()
    for k in keys
        tmp = Int32.([getfield((headers_block[i]), Symbol(k)) for i in 1:count])
        summary["$k"] = [minimum(tmp); maximum(tmp)]
    end # k
    
    # Collect in BlockScan and return
    scan = BlockScan(file, startbyte, endbyte, summary) 

    return scan
end
