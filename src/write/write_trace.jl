export write_trace

function write_trace(s::IO, block::SeisBlock, t::Int)
    
    ##000
    # Write Header
    for field in fieldnames(typeof(block.traceheaders[t]))
        write(s, getfield(block.traceheaders[t], field))
    end

    ##240
    # Write trace
    write(s, Float32.(block.data[:,t]))
end
