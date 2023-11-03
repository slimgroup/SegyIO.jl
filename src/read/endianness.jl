"""
bswap_needed(s::IO)

Checks whether SEGY and host machine's byte order are same or not.

NOTE: comparison is done based on binary file header value (Data Sample Format)
thus stream (s::IO) must be opened from the begining of the file.

# Examples

s = open("/my/segy.segy", "r")
swap_bytes = bswap_needed(s)
"""
function bswap_needed(s::IO)
    bfh = BinaryFileHeader()
    fh_b2s = fh_byte2sample()
    
    old_pos = position(s)
    seek(s, fh_b2s["DataSampleFormat"])
    dsf = read(s, typeof(bfh.DataSampleFormat))
    seek(s, old_pos)

    if dsf >= 1 && dsf <= 16
        return false
    else
        return true
    end
end
