export scan_block

function scan_block(buf::IO, mem_block::Int, mem_trace::Int, keys::Array{String,1},
                    chunk_start::Int, file::String, th_byte2sample::Dict{String, Int32})
    
    # Calc info about this block
    startbyte = position(buf) + chunk_start
    ntraces_block = Int(mem_block/mem_trace)
    headers = Array{BinaryTraceHeader,1}(ntraces_block)
    
    # Read all headers and record end byte
    for t in 1:ntraces_block

        headers[t] = read_traceheader(buf, keys, th_byte2sample)
        skip(buf, mem_trace-240)

    end # t
    endbyte = position(buf) + chunk_start
    
    # Parse headers for min/max
    metadata = Array{Array{Int32,1},1}(length(keys))
    for k in 1:length(keys)
        
        tmp = Int32.([getfield((headers[i]), Symbol(keys[k])) for i in 1:ntraces_block])
        metadata[k] = [minimum(tmp); maximum(tmp)]

    end # k
    
    # Collect in BlockScan and return
    scan = BlockScan(file, startbyte, endbyte, keys, metadata) 

    return scan
end
