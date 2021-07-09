export segy_write_append

function segy_write_append(file::String, block::SeisBlock)

    # Open buffer for writing
    s = open(file, "r+")


    # Write Data
    ns,ntraces = size(block.data)
    for t in 1:ntraces
        write_trace(seekend(s), block, t)
    end

    close(s)
end
