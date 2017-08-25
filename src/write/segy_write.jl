export segy_write

function segy_write(file::String, block::SeisBlock)

    # Open buffer for writing
    s = open(file, "w")

    # Write FileHeader
    write_fileheader(s, block.fileheader)

    # Write Data
    ns,ntraces = size(block.data)
    for t in 1:ntraces
        write_trace(s, block, t)
    end

    close(s)
end
