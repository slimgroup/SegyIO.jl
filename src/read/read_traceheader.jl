export read_traceheader, read_traceheader!

"""
# Info

Use: fileheader = read_fileheader(s::IO; bigendian::Bool = true)


Returns a binary trace header formed from the current position in the stream 's'.
"""
function read_traceheader(s::IO, th_byte2sample::Dict{String,Int32}; bigendian::Bool = true)

    traceheader = BinaryTraceHeader()
    
    if bigendian
        for k in keys(th_byte2sample)
            m = mark(s)
            skip(s, th_byte2sample[k])
            sym = Symbol(k)
            updateTH_b!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end
    else
        for k in keys(th_byte2sample)
            m = mark(s)
            skip(s, th_byte2sample[k])
            sym = Symbol(k)
            updateTH!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end

    end
    
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

    traceheader = BinaryTraceHeader()
    if bigendian
        for k in keys
            m = mark(s)
            skip(s, th_byte2sample[k])
            sym = Symbol(k)
            updateTH_b!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end
    else
        for k in keys
            m = mark(s)
            skip(s, th_byte2sample[k])
            sym = Symbol(k)
            updateTH!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end

    end
    
    skip(s, 240)

    return traceheader
end

"""
Use: read_traceheader!(s::IO, keys = Array{String,1}; bigendian::Bool = true)

Returns a binary trace header formed from the current position in the stream 's', only reading
header values denoted in 'keys'.
"""
function read_traceheader!(s::IO, keys::Array{String,1};
                                bigendian::Bool = true)

    traceheader = SeisIO.blank_th
    if bigendian
        for k in keys
            m = mark(s)
            skip(s, SeisIO.th_b2s[k])
            sym = Symbol(k)
            updateTH_b!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end
    else
        for k in keys
            m = mark(s)
            skip(s, SeisIO.th_b2s[k])
            sym = Symbol(k)
            updateTH!(s, traceheader, getfield(traceheader, sym), sym)
            reset(s)
        end

    end
    
    skip(s, 240)

    return nothing
end
function updateTH_b!{FT<:Number}(s::IO, th::BinaryTraceHeader, field::FT, sym::Symbol)
    val = bswap(read(s, FT))::FT
    setfield!(th, sym, val)
end

function updateTH!{FT<:Number}(s::IO, th::BinaryTraceHeader, field::FT, sym::Symbol)
    val = read(s, FT)::FT
    setfield!(th, sym, val)
end
