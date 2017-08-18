export read_trace

"""
read_trace(s::IO, fh::BinaryFileHeader)
Reads a single trace from the current position of stream 's'.
"""
function read_trace!(s::IO, fh::BinaryFileHeader, datatype::Type,
                    headers::Array{BinaryTraceHeader,1},
                    data::Array{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int)
    
    # Read trace header
    setindex!(headers, read_traceheader(s), trace)
    
    # Read trace
    setindex!(data, read_tracedata(s, fh, datatype), :, trace)
    
    nothing
end

"""

read_trace(s::IO, fh::BinaryFileHeader, datatype, headers, data, trace, keys)

Reads a single trace from the current position of stream 's' into 'headers' and
'data'. Only the header values in 'keys' and read.
"""
function read_trace!(s::IO, fh::BinaryFileHeader, datatype::Type,
                    headers::Array{BinaryTraceHeader,1},
                    data::Array{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int,
                    keys::Array{String,1})
    
    # Read trace header
    setindex!(headers, read_traceheader(s, keys), trace)
    
    # Read trace
    setindex!(data, read_tracedata(s, fh, datatype), :, trace)
    
    nothing
end
"""
Read a single trace from current position in stream as Float32
"""
function read_tracedata{DT<:Union{IBMFloat32, Float32}}(s::IO, fh::BinaryFileHeader, dsf::Type{DT})
    read(s, DT, fh.ns)
end

