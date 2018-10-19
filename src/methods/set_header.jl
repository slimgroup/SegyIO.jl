export set_header!, set_traceheader!, set_fileheader! 

# Set traceheader for vector
function set_traceheader!(traceheaders::Array{BinaryTraceHeader,1},
                          name::Symbol, x::ET) where {ET<:Array{<:Integer,1}}
    ftype = fieldtype(BinaryTraceHeader, name)
    try
        x_typed = convert.(ftype, x)

        for t in 1:length(traceheaders)
            setfield!(traceheaders[t], name, x_typed[t])
        end
    catch e
        @warn "Unable to convert $x to $(ftype)"
        throw(e)
    end
end

# Set fileheader
function set_fileheader!(fileheader::BinaryFileHeader,
                         name::Symbol, x::ET) where {ET<:Integer}
    ftype = fieldtype(BinaryFileHeader, name)
    try
        x_typed = convert.(ftype, x)
        setfield!(fileheader, name, x_typed)
    catch e
        @warn "Unable to convert $x to $(ftype)"
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
function set_header!(block::SeisBlock, name_in::Union{Symbol, String}, x::ET) where {ET<:Integer}
    name = Symbol(name_in)  
    ntraces = size(block)[2]
    x_vec = x.*ones(Int32, ntraces)

    # Try setting trace headers
    try
        set_traceheader!(block.traceheaders, name, x_vec)
    catch
    end

    # Try setting file header
    try
        set_fileheader!(block.fileheader.bfh, name, x)
    catch
    end
end

function set_header!(block::SeisBlock, name_in::Union{Symbol, String},
                     x::Array{ET,1}) where {ET<:Integer}
    name = Symbol(name_in)  
    ntraces = size(block)[2]

    # Try setting trace headers
    try
        set_traceheader!(block.traceheaders, name, x)
    catch
    end

    # Try setting file header
    try
        set_fileheader!(block.fileheader.bfh, name, x)
    catch
    end
end

