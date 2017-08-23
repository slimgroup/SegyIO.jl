export read_file

"""
read_file(s)

Read entire SEGY file from stream 's'.
"""
function read_file(s::IO; start_byte::Int = 3600, end_byte::Int = position(seekend(s)))
    
    # Read File Header
    fh = read_fileheader(s)
    
    # Move to start of block
    seek(s, start_byte)

    # Check datatype of file
    datatype = Float32
    if fh.dsf == 1
        datatype = IBMFloat32
    else
        error("Data type not supported ($(fh.dsf))")
    end

    # Check fixed length trace flag
    (fh.fltf != 0) && error("Fixed length trace flag set in stream: $s")
    
    ## Check for extended text header

    # Read traces
    ntraces = Int((end_byte - start_byte)/(240 + fh.ns*4))
    println("Reading $ntraces traces.")

    # Preallocate memory
    headers = Array{BinaryTraceHeader, 1}(ntraces)
    data = Array{datatype, 2}(fh.ns, ntraces)
    th_byte2sample = th_byte2sample()

    # Read each trace
    for trace in 1:ntraces

        read_trace!(s, fh, datatype, headers, data, trace, th_byte2sample)

    end

    return SeisBlock(fh, headers, data)
end

"""
read_file(s, keys)

Read entire SEGY file from stream 's', only reading the header values in 'keys'.
"""
function read_file(s::IO, keys::Array{String, 1}; start_byte::Int = 3600, end_byte::Int = position(seekend(s)))
    
    # Read File Header
    fh = read_fileheader(s)
    
    # Move to start of block
    seek(s, start_byte)

    # Check datatype of file
    datatype = Float32
    if fh.dsf == 1
        datatype = IBMFloat32
    else
        error("Data type not supported ($(fh.dsf))")
    end

    # Check fixed length trace flag
    (fh.fltf != 0) && error("Fixed length trace flag set in stream: $s")
    
    ## Check for extended text header

    # Read traces
    ntraces = Int((end_byte - start_byte)/(240 + fh.ns*4))
    println("Reading $ntraces traces.")

    # Preallocate memory
    headers = Array{BinaryTraceHeader, 1}(ntraces)
    data = Array{datatype, 2}(fh.ns, ntraces)
    th_byte2sample = th_byte2sample()

    # Read each trace
    for trace in 1:ntraces

        read_trace!(s, fh, datatype, headers, data, trace, keys, th_byte2sample)

    end

    return SeisBlock(fh, headers, data)
end
