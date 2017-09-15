import Base.size, Base.length

export SeisBlock, set_header!, set_traceheader!, set_fileheader!, get_header

mutable struct SeisBlock{DT<:Union{IBMFloat32, Float32}}
    fileheader::FileHeader
    traceheaders::Array{BinaryTraceHeader, 1}
    data::Array{DT,2}
end

size(block::SeisBlock) = size(block.data)
length(block::SeisBlock) = length(block.traceheaders)

function SeisBlock{DT<:Union{Float32, IBMFloat32}}(data::Array{DT,2})

    # Construct FileHeader
    ns, ntraces = size(data)
    fh = FileHeader()
    fh.bfh.ns = ns
    DT==Float32 ? fh.bfh.DataSampleFormat=5 : fh.bfh.DataSampleFormat=1
    
    # Construct TraceHeaders
    traceheaders = [BinaryTraceHeader() for i in 1:ntraces]
    set_traceheader!(traceheaders, :ns, ns*ones(Int16, ntraces))

    # Construct Block
    block = SeisBlock(fh, traceheaders, data)

    return block
end


# Set traceheader for vector
function set_traceheader!{ET<:Array{<:Integer,1}}(traceheaders::Array{BinaryTraceHeader,1},
                                            name::Symbol, x::ET)
    ftype = fieldtype(BinaryTraceHeader, name)
    try
        x_typed = convert.(ftype, x)

        for t in 1:length(traceheaders)
            setfield!(traceheaders[t], name, x_typed[t])
        end
    catch e
        warn("Unable to convert $x to $(ftype)")
        throw(e)
    end
end

# Set fileheader
function set_fileheader!{ET<:Integer}(fileheader::BinaryFileHeader,
                                            name::Symbol, x::ET)
    ftype = fieldtype(BinaryFileHeader, name)
    try
        x_typed = convert.(ftype, x)
        setfield!(fileheader, name, x_typed)
    catch e
        warn("Unable to convert $x to $(ftype)")
        throw(e)
    end
end

"""
set_header!(block, header, value)

Set the 'header' field in 'block' to 'value', where 'header' is either a string or symbol of a valid field in BinaryTraceHeader.

If 'value' is an Int, it will be applied to each header.
If 'value' is a vector, the i-th 'value' will be set in the i-th traceheader.

# Example

set_header!(block, "SourceX", 100)
set_header!(block, :SourceY, Array(1:100))
"""
function set_header!{ET<:Integer}(block::SeisBlock, name_in::Union{Symbol, String}, x::ET)
    name = Symbol(name_in)  
    ntraces = size(block)[2]
    x_vec = x.*ones(Int32, ntraces)

    # Try setting trace headers
    try
        set_traceheader!(block.traceheaders, name, x_vec)
    end

    # Try setting file header
    try
        set_fileheader!(block.fileheader.bfh, name, x)
    end
end

function set_header!{ET<:Integer}(block::SeisBlock, name_in::Union{Symbol, String},
                                                        x::Array{ET,1})
    name = Symbol(name_in)  
    ntraces = size(block)[2]

    # Try setting trace headers
    try
        set_traceheader!(block.traceheaders, name, x)
    end

    # Try setting file header
    try
        set_fileheader!(block.fileheader.bfh, name, x)
    end
end

"""
getheader(block, header)

Returns a vector of 'header' values from each trace in 'block'. Trace order is preserved.

# Example
sx = get_header(block, "SourceX")
sy = get_header(block, :SourceX)
"""
function get_header(block::SeisBlock, name_in::Union{Symbol, String}; scale::Bool = true)
    name = Symbol(name_in)
    ntraces = length(block)
    ftype = fieldtype(BinaryTraceHeader, name)
    out = zeros(ftype, ntraces)

    for i in 1:ntraces
        out[i] = getfield(block.traceheaders[i], name)
    end
    
    # Check to apply SrcRecScale
    if scale && name==:SourceX||name==:SourceY||name==:GroupX||name==:GroupY
        scaling_factor = get_header(block, :RecSourceScalar)
        out = Float64.(out)
        for ii in 1:ntraces
            fact = scaling_factor[ii]
            fact > 0 ? out[ii] *= fact : out[ii] /= abs(fact) 
        end
    end

    return out
end
