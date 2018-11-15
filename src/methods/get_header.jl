export get_header

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
    
    # Check, and apply scaling
    is_scalable, scale_name = check_scale(name) 
    if scale && is_scalable
        scaling_factor = get_header(block, scale_name)
        out = Float64.(out)
        for ii in 1:ntraces
            fact = scaling_factor[ii]
            fact > 0 ? out[ii] *= fact : out[ii] /= abs(fact) 
        end
    end

    return out
end

"""
    is_scalable, scale_name = check_scale(sym)

Checks to see if the BinaryTraceHeader field `sym` requires scaling.

`is_scalable` returns true if the field can be scaled, and `scale_name` returns
the symbol of the appropriate scaling field.
"""
function check_scale(sym::Symbol)
    recsrc = false
    el = false
    scale_name = :Null

    recsrc_str = "SourceX 
            SourceY
            GroupX
            GroupY
            CDPX
            CDPY"

    el_str = " RecGroupElevation            
          SourceSurfaceElevation       
          SourceDepth                  
          RecDatumElevation            
          SourceDatumElevation         
          SourceWaterDepth             
          GroupWaterDepth"

    if occursin(String(sym), recsrc_str) 
        recsrc = true
        scale_name = :RecSourceScalar
    elseif occursin(String(sym), el_str) 
        el = true
        scale_name = :ElevationScalar
    end

    return (recsrc||el), scale_name     
end

"""
    get_header(con::SeisCon, name::String)

Gets the metadata summary, `name`, from every `BlockScan` in `con`.
Column 1 contains the minimum value of `name` within the block, and Column 2
contains the maximum value of `name` within the block. Src/Rec scaling is not applied.

To get source coordinate pairs as an array, see `get_sources`. 

# Example

trace = get_header(s, "TraceNumber")

"""
function get_header(con::SeisCon,name::String)
    minmax = [con.blocks[i].summary[name] for i in 1:length(con)]
    I = length(minmax)
    vals = Array{Int32,2}(undef, I, 2)
    for i in 1:I
        vals[i,1] = minmax[i][1]
        vals[i,2] = minmax[i][2]
    end
    
    return vals
end
