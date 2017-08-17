export delim_vector

function delim_vector(x::AbstractVector, probe_length::Int)

    delims = Array{Int,1}(1)
    delims[1] = 1
    n = length(x)

    while true

        j = find_next_delim(x, delims[end], probe_length)

        (j < n) ? (push!(delims, j)) : (return delims)

    end
    
end 
