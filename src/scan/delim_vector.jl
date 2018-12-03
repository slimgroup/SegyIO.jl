export delim_vector

"""
    Use: delim_vector(x::AbstractVector, probe_length::Int)

Return the indicies of the first element for each homogenous section in `x`.

# Example
```
julia> x = vec([1.0 1.0 1.0 2.0 2.0 2.0 2.0 3.0 3.0 3.0 3.0]);

julia> delim_vector(x, 1)
3-element Array{Int64,1}:
1
4
8
```

`probe_length` sets the intial guess for the section length. Choosing `probe_length` close the the true length of the section provides modest performance benefits, however simply setting the length to 1 is not a huge hit.

```
julia> @btime delim_vector(x,1)
  1.169 μs (3 allocations: 176 bytes)
4-element Array{Int64,1}:
      1
 100001
 100003
 200003

julia> @btime delim_vector(x,100000)
  945.615 ns (3 allocations: 176 bytes)
4-element Array{Int64,1}:
      1
 100001
 100003
 200003
```
"""
function delim_vector(x::AbstractVector, probe_length::Int)

    delims = Array{Int,1}(undef, 1)
    delims[1] = 1
    n = length(x)

    while true
        j = find_next_delim(x, delims[end], probe_length)
        (j < n) ? (push!(delims, j)) : (return delims)
    end
    
end 
