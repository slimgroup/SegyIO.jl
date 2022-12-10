export BlockScan

mutable struct BlockScan
    file::AbstractString
    startbyte::Int
    endbyte::Int
    summary::Dict{String, Array{Int32, 1}}
end

