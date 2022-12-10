export read_traceheader

"""
# Info

Use: fileheader = read_fileheader(s::IO; bigendian::Bool = true)


Returns a binary trace header formed from the current position in the stream 's'.
"""
function read_traceheader(s::IO, th_byte2sample::Dict{String,Int32}; bigendian::Bool = true)
    return read_traceheader(s, collect(keys(th_byte2sample)), th_byte2sample; bigendian=bigendian)
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

    # read full trace header then split
    th = read(s, 240)
    
    # Read all header values and put in fileheader
    for k in keys
        sym = Symbol(k)
        nb = sizeof(getfield(traceheader, sym))-1
        bst = th_byte2sample[k]+1
        val = reinterpret(typeof(getfield(traceheader, sym)), th[bst:bst+nb])[1]
        bigendian && (val = bswap(val))
        setfield!(traceheader, sym, val)
    end

    return traceheader
end
