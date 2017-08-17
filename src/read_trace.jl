export read_trace

"""
read_trace(s::IO, fh::BinaryFileHeader)
Reads a single trace from the current position of stream 's'.
"""
function read_trace(s::IO, fh::BinaryFileHeader, datatype::Type)
    
    # Read trace header
    th = read_traceheader(s)
    
    # Read trace
    d = read_tracedata(s, fh, datatype)

    return SeisTrace(th,d)
end

"""
read_tracedata(s::IO, fh::BinaryFileHeader, dsf::DataType)

Read a single trace from current position in stream as IBMFloat32
"""
function read_tracedata(s::IO, fh::BinaryFileHeader, dsf::Type{IBMFloat32})
    read(s, IBMFloat32, fh.ns)
end

"""
Read a single trace from current position in stream as Float32
"""
function read_tracedata(s::IO, fh::BinaryFileHeader, dsf::Type{Float32})
    read(s, IBMFloat32, fh.ns)
end

