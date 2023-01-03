export read_block_headers!

function read_block_headers!(b::BlockScan, keys::Array{String, 1}, ns::Int, dsf::Int, headers)

    f = open(b.file)
    seek(f, b.startbyte)
    brange = b.endbyte - b.startbyte
    s = IOBuffer(read(f, brange))
    ntraces = Int((brange)/(240 + ns*4))
    fh = FileHeader()
    fh.bfh.ns = ns
    fh.bfh.DataSampleFormat = dsf

    # Check dsf
    datatype = Float32
    if fh.bfh.DataSampleFormat == 1
        datatype = IBMFloat32
    elseif fh.bfh.DataSampleFormat != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    th_b2s = th_byte2sample()
    tmph = zeros(UInt8, 240)
    # Read each traceheader
    for trace in 1:ntraces
        read_traceheader!(s, keys, th_b2s, headers[trace]; th=tmph)
        skip(s, ns*4)
    end

end

function read_block_headers!(b::BlockScan, ns::Int, dsf::Int, headers)

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
    elseif fh.bfh.DataSampleFormat != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    th_b2s = th_byte2sample()
    # Read each traceheader
    for trace in 1:ntraces
        read_traceheader!(s, th_b2s, headers[trace])
        skip(s, ns*4)
    end

end
