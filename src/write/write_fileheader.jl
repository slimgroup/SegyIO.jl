export write_fileheader

function write_fileheader(s::IO, fh::FileHeader)
    
    # Check text header length
    sizeof(fh.th) > 3200 ? throw(error("Text Header longer than 3200 bytes")) : false

    # Check dsf
    if fh.bfh.DataSampleFormat != 5
        warn("DataSampleFormat not supported for writing. Attempting to convert to IEEE Float32")
        fh.bfh.DataSampleFormat = 5
    end
    
    ##0000
    # Write Text header #DEVNOTE# Big Endian?
    th_length = write(s, fh.th)
    
    # If too short, pad with blanks
    if th_length < 3200
        pad = 3200 - th_length
        write(s, " "^pad)
    end
    
    ##3200
    # Write first section of assigned values
    for field in fieldnames(fh.bfh)[1:27]
        write(s, bswap(getfield(fh.bfh, field)))
    end
    
    ##3260
    # Skip to next block
    write(s, Array{UInt8,1}(240))
    
    ##3500
    # Write second section of assigned values
    for field in fieldnames(fh.bfh)[28:end]
        write(s, bswap(getfield(fh.bfh, field)))
    end
    
    ##3506
    # Skip to end
    write(s, Array{UInt8,1}(94))
    
    ##3600

end
