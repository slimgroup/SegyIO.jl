export read_traces

"""
Use:    read_traces!(s::IO,
                    fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int, 
                    th_byte2sample::Dict{String,Int32};
                    swap_bytes::Bool)

Reads 'trace' from the current position of stream 's' into 'headers' and
'data'. 
"""
function read_traces!(s::IO, headers::AbstractVector{BinaryTraceHeader},
                      data::AbstractMatrix{<:Union{IBMFloat32, Float32}},
                      th_byte2sample::Dict{String,Int32};
                      swap_bytes::Bool)

    return read_traces!(s, headers, data, collect(keys(th_byte2sample)), th_byte2sample; swap_bytes=swap_bytes)
end

"""
Use:    read_traces!(s::IO,
                    fh::BinaryFileHeader,
                    datatype::Type,
                    headers::AbstractArray{BinaryTraceHeader,1},
                    data::AbstractArray{<:Union{IBMFloat32, Float32}, 2},
                    trace::Int,
                    keys::Array{String,1},
                    th_byte2sample::Dict{String,Int32};
                    swap_bytes::Bool)

Reads 'trace' from the current position of stream 's' into 'headers' and
'data'. Only the header values in 'keys' and read.
"""
function read_traces!(s::IO, headers::AbstractVector{BinaryTraceHeader},
                      data::AbstractMatrix{DT}, keys::Array{String,1},
                      th_byte2sample::Dict{String,Int32}; swap_bytes::Bool) where {DT<:Union{IBMFloat32, Float32}}

    ntrace = size(data, 2)
    ntrace == 0 && return
    tmph = zeros(UInt8, 240)
    for trace_loc=0:ntrace-1
        # Read trace header
        read_traceheader!(s, keys, th_byte2sample, headers[trace_loc+1]; swap_bytes=swap_bytes, th=tmph)
        # Read trace
        read!(s, view(data, :, trace_loc+1))
    end
    (swap_bytes) && (data = bswap.(data))
    nothing
end
