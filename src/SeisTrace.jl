export SeisTrace

type SeisTrace

    traceheader::BinaryTraceHeader
    data::Array{<:Union{IBMFloat32, Float32},1}

end
