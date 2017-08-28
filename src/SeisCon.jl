import Base.size

export SeisCon, size

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

    
