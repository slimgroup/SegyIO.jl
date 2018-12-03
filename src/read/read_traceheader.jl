export read_traceheader

"""
# Info

Use: fileheader = read_fileheader(s::IO; bigendian::Bool = true)


Returns a binary trace header formed from the current position in the stream 's'.
"""
function read_traceheader(s::IO, th_byte2sample::Dict{String,Int32}; bigendian::Bool = true)

    # Initialize binary file header
    traceheader = BinaryTraceHeader()
    
    if bigendian

        # Read all header values and put in fileheader
        for k in keys(th_byte2sample)

            # Mark start of trace header
            m = mark(s)

            # Seek to this header value location
            skip(s, th_byte2sample[k])

            sym = Symbol(k)
            updateTH_b!(s, traceheader, getfield(traceheader, sym), sym)

            # Return to mark
            reset(s)
        end

    else

        # Read all header values and put in fileheader
        for k in keys(th_byte2sample)

            # Mark start of trace header
            m = mark(s)

            # Seek to this header value location
            skip(s, th_byte2sample[k])

            sym = Symbol(k)
            updateTH!(s, traceheader, getfield(traceheader, sym), sym)

            # Return to mark
            reset(s)
        end

    end
    
    # Seek to end of trace
    skip(s, 240)

    return traceheader
end

"""
Use: fileheader = read_traceheader(s::IO, keys = Array{String,1}; bigendian::Bool = true)

Returns a binary trace header formed from the current position in the stream 's', only reading
header values denoted in 'keys'.
"""
function read_traceheader(s::IO, keys::Array{String,1}, th_byte2sample::Dict{String, Int32};
                                bigendian::Bool = true)

    # Initialize binary file header
    traceheader = BinaryTraceHeader()
    
    if bigendian

        # Read all header values and put in fileheader
        for k in keys

            # Mark start of trace header
            m = mark(s)

            # Seek to this header value location
            skip(s, th_byte2sample[k])

            sym = Symbol(k)
            updateTH_b!(s, traceheader, getfield(traceheader, sym), sym)

            # Return to mark
            reset(s)
        end

    else

        # Read all header values and put in fileheader
        for k in keys

            # Mark start of trace header
            m = mark(s)

            # Seek to this header value location
            skip(s, th_byte2sample[k])

            sym = Symbol(k)
            updateTH!(s, traceheader, getfield(traceheader, sym), sym)

            # Return to mark
            reset(s)
        end

    end
    
    # Seek to end of trace
    skip(s, 240)

    return traceheader
end

function updateTH_b!(s::IO, th::BinaryTraceHeader, field::FT, sym::Symbol) where {FT<:Number}
    val = bswap(read(s, FT))::FT
    setfield!(th, sym, val)
end

function updateTH!(s::IO, th::BinaryTraceHeader, field::FT, sym::Symbol) where {FT<:Number}
    val = read(s, FT)::FT
    setfield!(th, sym, val)
end
