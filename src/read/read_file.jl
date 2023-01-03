export read_file

"""
read_file(s)

Read entire SEGY file from stream 's'.
"""
function read_file(s::IO, warn_user::Bool; start_byte::Int = 3600,
                   end_byte::Int = position(seekend(s)))
    # Read with all keys
    return read_file(s, th_keys(), warn_user; start_byte=start_byte, end_byte=end_byte)
end

"""
read_file(s, keys)

Read entire SEGY file from stream 's', only reading the header values in 'keys'.
"""
function read_file(s::IO, keys::Array{String, 1}, warn_user::Bool; 
                   start_byte::Int = 3600, end_byte::Int = position(seekend(s)))
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
    trace_size = (240 + fh.bfh.ns*4)
    ntraces = Int((end_byte - start_byte)/trace_size)

    # Preallocate memory
    headers = zeros(BinaryTraceHeader, ntraces)
    data = Array{datatype, 2}(undef, fh.bfh.ns, ntraces)
    th_b2s = th_byte2sample()

    # Read each trace
    ref = position(s)
    for trace in 1:TRACE_CHUNKSIZE:ntraces
        seek(s, (trace - 1) * trace_size + ref)
        tracee = min(trace + TRACE_CHUNKSIZE - 1, ntraces)
        chunk = length(trace:tracee)*trace_size
        sloc = IOBuffer(read(s, chunk))
        read_traces!(sloc, view(headers, trace:tracee), view(data, :, trace:tracee), keys, th_b2s)
    end

    return SeisBlock(fh, headers, data)
end
