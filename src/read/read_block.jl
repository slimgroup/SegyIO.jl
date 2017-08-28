export read_block!

function read_block!(b::BlockScan, keys::Array{String, 1}, ns::Int, dsf::Int, tmp_data, tmp_headers)

    f = open(b.file)
    seek(f, b.startbyte)
    brange = b.endbyte - b.startbyte
    s = IOBuffer(read(f, brange))
    ntraces = Int((brange)/(240 + ns*4))
    fh = FileHeader()
    fh.bfh.ns = ns; fh.bfh.DataSampleFormat = dsf

    # Check dsf
    datatype = Float32
    if fh.bfh.DataSampleFormat == 1
        datatype = IBMFloat32
    elseif con.dsf != 5
        error("Data type not supported ($(fh.bfh.DataSampleFormat))")
    end

    th_b2s = th_byte2sample()
    # Read each trace
    for trace in 1:ntraces
        read_trace!(s, fh.bfh, datatype, tmp_headers, tmp_data, trace, keys, th_b2s)
    end

end
