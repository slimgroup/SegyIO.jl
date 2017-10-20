export InterpRegion, blocks_in_region 
import Base.extrema

struct InterpRegion

    size::Tuple{Int, Int, Int, Int}
    ds::Number
    dr::Number
    origin::Tuple{Number, Number}

end


function blocks_in_region(s::SeisCon, r::InterpRegion)

    srcs = get_sources(s)
    blocks = find(map((x,y) -> inregion(r.xlim, r.ylim, x, y),srcs[:,1], srcs[:,2]))

    return blocks

end

inregion(limx, limy, x, y) = (limx[1] < x < limx[2]) && (limy[1] < y < limy[2])
