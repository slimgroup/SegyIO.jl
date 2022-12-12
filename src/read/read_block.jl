export read_block!

function read_block!(b::BlockScan, ns::Int, dsf::Int, tmp_data, tmp_headers)
    read_block!(b, th_keys(), ns, dsf, tmp_data, tmp_headers)
end

function read_block!(b::BlockScan, keys::Array{String, 1}, ns::Int, dsf::Int, tmp_data, tmp_headers)

    f = open(b.file)
    seek(f, b.startbyte)
    brange = b.endbyte - b.startbyte
    s = IOBuffer(read(f, brange))
    trace_size = (240 + ns*4)
    ntraces = Int((brange)/trace_size)
    fh = FileHeader()
    fh.bfh.ns = ns; fh.bfh.DataSampleFormat = dsf

    # Check dsf
    datatype = Float32
    if fh.bfh.DataSampleFormat == 1
        datatype = IBMFloat32
    elseif fh.bfh.DataSampleFormat != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    th_b2s = th_byte2sample()
    # Read each trace
    for trace in 1:TRACE_CHUNKSIZE:ntraces
        tracee = min(trace + TRACE_CHUNKSIZE - 1, ntraces)
        chunk = length(trace:tracee)*trace_size
        sloc = IOBuffer(read(s, chunk))
        read_traces!(sloc, view(tmp_headers, trace:tracee), view(tmp_data, :, trace:tracee), keys, th_b2s)
    end
end
