export read_file

"""
readfile(s)

Read entire SEGY file from stream 's'.
"""
function read_file(s::IO)
    
    # Read File Header
    fsize = position(seekend(s))
    fh = read_fileheader(s)

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
    ntraces = Int((fsize - 3600)/(240 + fh.ns*4))
    println(ntraces)

    # Preallocate memory

    d = [read_trace(s, fh, datatype) for t in 1:ntraces]        
    
    return fh, d
end
