export segy_write

function segy_write(file::String, block::SeisBlock)
    # Open buffer for writing
    s = open(file, "w")
    segy_write(s, block)
    close(s)
end

function segy_write(s::IO, block::SeisBlock)
    # Write FileHeader
    write_fileheader(s, block.fileheader)

    # Write Data
    ns, ntraces = size(block.data)
    for t in 1:ntraces
        write_trace(s, block, t)
    end
end
