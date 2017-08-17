export read_block

"""
Reads a block of traces out of a SEGY files defined by the starting and
ending byte of the block.
"""
function read_block(s::IOStream, startbyte::Int, endbyte::Int)

    # Seek to the starting byte of the block
    seek(fid, startbyte)

    # Read entire block as UInt8
    nbytes = endbyte - startbyte
    d = read(s, nbytes)

    return d


end
