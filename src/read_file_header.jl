export read_file_header

"""
Use: textheader, binaryheader = read_file_header()
Return the file header from a SEGY file
"""
function read_file_header(s::IOStream)

    # Seek to start of stream
    seekstart(s)

    # Read in text and binary header
    raw = read(s, 3600)
    
    # Form the headers
    textheader = @views raw[1:3200]
    binaryheader = @views raw[3201:3600]
    
    io_th = IOBuffer(textheader)
    io_bh = IOBuffer(binaryheader)
    
    return io_th, io_bh
end

