import Base.copy

export BlockScan

mutable struct BlockScan
    file::AbstractString
    startbyte::Int
    endbyte::Int
    summary::Dict{String, Array{Int32, 1}}
end

"""
    copy(b::BlockScan)

Create a copy of SeisCon object.
"""
copy(b::BlockScan) = BlockScan(b.file, b.startbyte, b.endbyte, b.summary)