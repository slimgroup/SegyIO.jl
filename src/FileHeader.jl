export FileHeader

type FileHeader
    th::String
    bfh::BinaryFileHeader
end

function show(io::IO, fh::FileHeader)
    
    println("Text Header: ")
    println(fh.th, "/n")
    
    show(fh.bfh)
end
