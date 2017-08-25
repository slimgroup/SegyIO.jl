import Base.size

export SeisBlock

type SeisBlock{DT<:Union{IBMFloat32, Float32}}
    fileheader::FileHeader
    traceheaders::Array{BinaryTraceHeader, 1}
    data::Array{DT,2}
end

size(block::SeisBlock) = size(block.data)
