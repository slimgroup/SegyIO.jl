export BlockScan

mutable struct BlockScan
    file::String
    startbyte::Int
    endbyte::Int
    summary::Dict{String, Array{Int32, 1}}
end

