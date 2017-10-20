export Patch, makepatches

struct Patch{DT<:Union{Complex{Float32}, Float32}}
    data::Vector{DT}
    id::Tuple{Integer, Integer, Integer}
end

function makepatches(d::SeisBlock, id::Tuple{Int, Int}, inds, transform::Function)
    
    # Save Zone Headers
    sx = get_header(d, :SourceX)
    sy = get_header(d, :SourceY)
    rx = get_header(d, :GroupX)
    ry = get_header(d, :GroupY)
    
    headers = hcat(sx, sy, rx, ry)
    D = transform(Float32.(d.data),1) 
    p = [Patch(D[i,:], (id[1], id[2], i)) for i in inds] 

    return p, headers

end
