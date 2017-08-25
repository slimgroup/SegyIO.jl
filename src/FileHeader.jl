export FileHeader

type FileHeader
    th::String
    bfh::BinaryFileHeader
end

function show(io::IO, fh::FileHeader)
    show(fh.bfh)
end
