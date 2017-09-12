# SeisCon type definition and methods
import Base.size, Base.length, Base.getindex

export SeisCon, size, get_sources, getindex, merge_con, split_con

struct SeisCon
    ns::Int
    dsf::Int
    blocks::Array{BlockScan,1}
end

# Parameters
size(con::SeisCon) = size(con.blocks)
length(con::SeisCon) = length(con.blocks)

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
    vals = Array{Int32,2}(I,2)
    for i in 1:I
        vals[i,1] = minmax[i][1]
        vals[i,2] = minmax[i][2]
    end
    
    return vals
end

"""
    get_sources(con::SeisCon)

Returns an array of the source location coordinate pairs, NOT the minimum and maximum values.
Unlike `get_headers`, `get_sources` checks to make sure that SourceX and SourceY are consistant
throughout each block, that is `min == max`. 

Column 1 of the returned array is SourceX, and Column 2 is SourceY.

# Example

sx = get_sources(s)

"""
function get_sources(con::SeisCon)

    sx_v = get_header(con, "SourceX")
    sy_v = get_header(con, "SourceY")
    
    sx_const = all([sx_v[i][1] == sx_v[i][2] for i in 1:length(sx_v)])
    sy_const = all([sy_v[i][1] == sy_v[i][2] for i in 1:length(sy_v)])
    
    if sx_const && sy_const
        sx = [sx_v[i][1] for i in 1:length(sx_v)]
        sy = [sy_v[i][1] for i in 1:length(sy_v)]
    else
        throw(error("Source locations are not constistant for all blocks."))
    end

    return hcat(sx,sy)

end

function getindex{TA<:Union{Array{<:Integer,1}, Range, Integer}}(con::SeisCon, a::TA) 
    read_con(con, a)
end
function getindex(con::SeisCon, a::Colon) 
    read_con(con, 1:length(con))
end

"""
    merge_cons(cons::Array{SeisCon,1})

Merge `con`, a vector of SeisCon objects, into one SeisCon object. 
"""
function merge_con(cons::Array{SeisCon,1})
    
    # Check similar metadata
    ns = get_confield(cons, :ns)
    dsf = get_confield(cons, :dsf)

    if all(ns.==ns[1]) && all(dsf.==dsf[1])
        d = [cons[i].blocks for i in 1:length(cons)]
        return SeisCon(ns[1], dsf[1], vcat(d...))
    else
        throw(error("Dissimilar metadata, cannot merge"))
    end
end

"""
    merge_con(a::SeisCon, b::SeisCon)

Merge two SeisCon objects together
"""
merge_con(a::SeisCon, b::SeisCon) = merge_con([a; b])

"""
    get_confield(cons::Array{SeisCon,1}, name::Symbol)

Returns an Array{Int32,1} containing the value in `name` field of each SeisCon object.
"""
function get_confield(cons::Array{SeisCon,1}, name::Symbol)
    ncons = length(cons)
    out = zeros(Int64, ncons)
    for i in 1:ncons
        out[i] = getfield(cons[i], name)
    end
    return out
end

"""
   c = split_con(s::SeisCon, inds)

Creates a new SeisCon object `c` without copying by referencing `s.blocks[inds]`

`inds` can be an array of indicies, a range, or a scalar.

# Example
```julia-repl
julia> b = split_con(s, 1:10);
julia> c = split_con(b, [1; 7; 9]);
julia> d = split_con(c, 1);
```
And we can confirm that `d` and `s` reference the same place in memory.

```julia-repl
julia> s.blocks[1] === d.blocks[1]
true
```
"""
function split_con{Ti<:Integer}(s::SeisCon, inds::Union{Vector{Ti}, Range{Ti}})
    c = SeisCon(s.ns, s.dsf, view(s.blocks, inds)) 
end

split_con(s::SeisCon, inds::Integer) = split_con(s, [inds])
