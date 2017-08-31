import Base.size, Base.getindex

export SeisCon, size, get_sourcesi, getindex

struct SeisCon
    ns::Int
    dsf::Int
    blocks::Array{BlockScan,1}
end

"""
size(con)

Returns the number of blocks covered in the scan
"""
size(con::SeisCon) = length(con.blocks)

get_header(con::SeisCon,name::String)=[con.blocks[i].summary[name] for i in 1:size(con)]      

"""
    get_sources(con::SeisCon)

Return an 

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
