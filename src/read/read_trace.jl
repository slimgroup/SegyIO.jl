export read_trace

"""
Use:    read_trace!(s::IO,
                    fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int, 
                    th_byte2sample::Dict{String,Int32})

Reads 'trace' from the current position of stream 's' into 'headers' and
'data'. 
"""
function read_trace!(s::IO, fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int, 
                    th_byte2sample::Dict{String,Int32})
    
    # Read trace header
    setindex!(headers, read_traceheader(s, th_byte2sample), trace)
    
    # Read trace
    setindex!(data, read_tracedata(s, fh, datatype), :, trace)
    
    nothing
end

"""
Use:    read_trace!(s::IO,
                    fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int,
                    keys::Array{String,1},
                    th_byte2sample::Dict{String,Int32})

Reads 'trace' from the current position of stream 's' into 'headers' and
'data'. Only the header values in 'keys' and read.
"""
function read_trace!(s::IO, fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int,
                    keys::Array{String,1},
                    th_byte2sample::Dict{String,Int32})
    
    # Read trace header
    setindex!(headers, read_traceheader(s, keys, th_byte2sample), trace)
    
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

