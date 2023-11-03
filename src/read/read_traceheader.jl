export read_traceheader

"""
# Info

Use: fileheader = read_fileheader(s::IO; swap_bytes::Bool)


Returns a binary trace header formed from the current position in the stream 's'.
"""
function read_traceheader(s::IO, th_byte2sample::Dict{String,Int32}; swap_bytes::Bool, th=zeros(UInt8, 240))
    return read_traceheader(s, collect(keys(th_byte2sample)), th_byte2sample; swap_bytes=swap_bytes, th=th)
end

"""
Use: fileheader = read_traceheader(s::IO, keys = Array{String,1}; swap_bytes::Bool)

Returns a binary trace header formed from the current position in the stream 's', only reading
header values denoted in 'keys'.
"""
function read_traceheader(s::IO, keys::Array{String,1}, th_byte2sample::Dict{String, Int32};
                          swap_bytes::Bool, th=zeros(UInt8, 240))

    # Initialize binary file header
    traceheader = BinaryTraceHeader()

    read_traceheader!(s, keys, th_byte2sample, traceheader; swap_bytes=swap_bytes, th=th)
    return traceheader
end

function read_traceheader!(s::IO, keys::Array{String,1}, th_byte2sample::Dict{String, Int32}, hdr::BinaryTraceHeader;
                          swap_bytes::Bool, th=zeros(UInt8, 240))
    
    # read full trace header then split
    read!(s, th)
    
    # Read all header values and put in fileheader
    for k in keys
        sym = Symbol(k)
        nb = sizeof(getfield(hdr, sym)) - 1
        bst = th_byte2sample[k]+1
        val = reinterpret(typeof(getfield(hdr, sym)), th[bst:bst+nb])[1]
        swap_bytes && (val = bswap(val))
        setfield!(hdr, sym, val)
    end
    nothing
end

read_traceheader!(s::IO, thb::Dict{String, Int32}, hdr::BinaryTraceHeader; swap_bytes::Bool, th=zeros(UInt8, 240)) =
    read_traceheader!(s, collect(keys(thb)), thb, hdr; swap_bytes=swap_bytes, th=th)