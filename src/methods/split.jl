import Base.split

export split

"""
   c = split(s::SeisCon, inds)

Creates a new SeisCon object `c` without copying by referencing `s.blocks[inds]`

`inds` can be an array of indicies, a range, or a scalar.

# Example
```julia-repl
julia> b = split(s, 1:10);
julia> c = split(b, [1; 7; 9]);
julia> d = split(c, 1);
```
And we can confirm that `d` and `s` reference the same place in memory.

```julia-repl
julia> s.blocks[1] === d.blocks[1]
true
```
"""
function split{Ti<:Integer}(s::SeisCon, inds::Union{Vector{Ti}, Range{Ti}})
    c = SeisCon(s.ns, s.dsf, view(s.blocks, inds)) 
end

split(s::SeisCon, inds::Integer) = split(s, [inds])
