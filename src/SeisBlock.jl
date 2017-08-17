export SeisBlock

type SeisBlock{DT<:Union{IBMFloat32, Float32}}
    fileheader::BinaryFileHeader
    traceheaders::Array{BinaryTraceHeader, 1}
    data::Array{DT,2}
end
