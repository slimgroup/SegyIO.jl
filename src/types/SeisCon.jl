# SeisCon type definition and methods
import Base.size, Base.length, Base.getindex, Base.show

export SeisCon, size, getindex, merge_con, split_con, show

struct SeisCon
    ns::Int
    dsf::Int
    blocks::Array{BlockScan,1}
end

size(con::SeisCon) = size(con.blocks)
length(con::SeisCon) = length(con.blocks)

function getindex(con::SeisCon, a::TA) where {TA<:Union{Array{<:Integer,1}, AbstractRange, Integer}} 
    read_con(con, a)
end

function getindex(con::SeisCon, a::Colon) 
    read_con(con, 1:length(con))
end

#=
function show(s::SeisCon)
   
    nblocks = length(s)
    for block in in 1:n_blocks
        #file = s.blocks[block].file
        #file_short = "$(file[1:8]) ... $(file[end-16 : end])"

        # BlockID | File | StartByte | EndByte
        s = @sprintf "%6s %9d" String(field) getfield(bth, field)
        println(s)
    end
    println("\n")
    
end
=#



### DEPRECATED ### 09/15/2017
"""
    merge_cons(cons::Array{SeisCon,1})

Merge `con`, a vector of SeisCon objects, into one SeisCon object. 
"""
function merge_con(cons::Array{SeisCon,1})
    
    @warn "merge_con is deprecated, use merge"

    # Check similar metadata
    ns = get_confield(cons, :ns)
    dsf = get_confield(cons, :dsf)

    if all(ns.==ns[1]) && all(dsf.==dsf[1])
        d = [cons[i].blocks for i in 1:length(cons)]
        return SeisCon(ns[1], dsf[1], vcat(d...))
    else
        @error "Dissimilar metadata, cannot merge"
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
function split_con(s::SeisCon, inds::Union{Vector{Ti}, AbstractRange{Ti}}) where {Ti<:Integer}
    @warn "split_con is deprecated, use split"
    c = SeisCon(s.ns, s.dsf, view(s.blocks, inds)) 
end

split_con(s::SeisCon, inds::Integer) = split_con(s, [inds])
