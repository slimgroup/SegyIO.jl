export write_file

function write_file(file::String, block::SeisBlock)

    # Open file for writing
    s = open(file, "w")

    # Write FileHeader
    write_fileheader(s, block.fileheader)
    println("File Header: Complete - pos:$(position(s))") 

    # Write Data
    ns,ntraces = size(block.data)
    for t in 1:ntraces
        write_trace(s, block, t)
    end

    close(s)
end
