export BlockScan

type BlockScan
    file::String
    startbyte::Int
    endbyte::Int
    keys::Array{String,1}
    minmax::Array{Array{Int32,1},1}
end

