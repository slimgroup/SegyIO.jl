export write_trace

function write_trace(s::IO, block::SeisBlock, t::Int)
    
    println(position(s)) 
    ##000
    # Write first section of assigned values
    for field in fieldnames(block.traceheaders[t])
        write(s, bswap(getfield(block.traceheaders[t], field)))
    end

    println(position(s)) 
    ##210
    # Skip to next block
    write(s, Array{UInt8,1}(28))

    println(position(s)) 
    ##240
    # Write trace
    write(s, bswap.(Float32.(block.data[:,t])))
    
    println(position(s)) 
end
