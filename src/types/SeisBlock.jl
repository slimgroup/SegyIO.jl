import Base.size, Base.length

export SeisBlock, set_header!, set_traceheader!, set_fileheader! 

mutable struct SeisBlock{DT<:Union{IBMFloat32, Float32}}
    fileheader::FileHeader
    traceheaders::AbstractArray{BinaryTraceHeader, 1}
    data::AbstractArray{DT,2}
end

size(block::SeisBlock) = size(block.data)
length(block::SeisBlock) = length(block.traceheaders)

function SeisBlock(data::Matrix{DT}) where {DT<:Union{Float32, IBMFloat32}}

    # Construct FileHeader
    ns, ntraces = size(data)
    fh = FileHeader()
    fh.bfh.ns = ns
    DT==Float32 ? fh.bfh.DataSampleFormat=5 : fh.bfh.DataSampleFormat=1
    
    # Construct TraceHeaders
    traceheaders = zeros(BinaryTraceHeader, ntraces)
    set_traceheader!(traceheaders, :ns, ns*ones(Int16, ntraces))

    # Construct Block
    block = SeisBlock(fh, traceheaders, data)

    return block
end

function SeisBlock(data::Vector{DT}) where {DT<:Union{Float32, IBMFloat32}}
    return SeisBlock(reshape(data, :, 1))
end