export write_trace

function write_trace(s::IO, block::SeisBlock, t::Int)
    
    ##000
    # Write Header
    for field in fieldnames(typeof(block.traceheaders[t]))
        write(s, bswap(getfield(block.traceheaders[t], field)))
    end

    ##240
    # Write trace
    write(s, bswap.(Float32.(block.data[:,t])))
end
