export read_file

"""
read_file(s)

Read entire SEGY file from stream 's'.
"""
function read_file(s::IO, warn_user::Bool; start_byte::Int = 3600,
                                           end_byte::Int = position(seekend(s)))
    
    # Read File Header
    fh = read_fileheader(s)
    
    # Move to start of block
    seek(s, start_byte)

    # Check datatype of file
    datatype = Float32
    if fh.bfh.DataSampleFormat == 1
        datatype = IBMFloat32
    elseif fh.bfh.DataSampleFormat != 5
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    # Check fixed length trace flag
    (fh.bfh.FixedLengthTraceFlag!=1 & warn_user) && @warn "Fixed length trace flag set in stream: $s"
    
    ## Check for extended text header

    # Read traces
    ntraces = Int((end_byte - start_byte)/(240 + fh.bfh.ns*4))

    # Preallocate memory
    headers = Array{BinaryTraceHeader, 1}(undef, ntraces)
    data = Array{datatype, 2}(undef, fh.bfh.ns, ntraces)
    th_b2s = th_byte2sample()

    # Read each trace
    for trace in 1:ntraces

        read_trace!(s, fh.bfh, datatype, headers, data, trace, th_b2s)

    end

    return SeisBlock(fh, headers, data)
end

"""
read_file(s, keys)

Read entire SEGY file from stream 's', only reading the header values in 'keys'.
"""
function read_file(s::IO, keys::Array{String, 1}, warn_user::Bool; 
                                                  start_byte::Int = 3600,
                                                  end_byte::Int = position(seekend(s)))
    
    # Read File Header
    fh = read_fileheader(s)
    
    # Move to start of block
    seek(s, start_byte)

    # Check datatype of file
    datatype = Float32
    if fh.bfh.DataSampleFormat == 1
        datatype = IBMFloat32
    else
        @error "Data type not supported ($(fh.bfh.DataSampleFormat))"
    end

    # Check fixed length trace flag
    (fh.bfh.FixedLengthTraceFlag!=1 & warn_user) && @warn "Fixed length trace flag set in stream: $s"
    
    ## Check for extended text header

    # Read traces
    ntraces = Int((end_byte - start_byte)/(240 + fh.bfh.ns*4))

    # Preallocate memory
    headers = Array{BinaryTraceHeader, 1}(undef, ntraces)
    data = Array{datatype, 2}(undef, fh.bfh.ns, ntraces)
    th_b2s = th_byte2sample()

    # Read each trace
    for trace in 1:ntraces

        read_trace!(s, fh.bfh, datatype, headers, data, trace, keys, th_b2s)

    end

    return SeisBlock(fh, headers, data)
end
