module SeisIO

    #Types
    include("IBMFloat32.jl")
    include("BinaryFileHeader.jl")
    include("BinaryTraceHeader.jl")
    include("FileHeader.jl")
    include("SeisBlock.jl")
    include("scan/BlockScan.jl")

    # Methods

        #Reader
        include("read/read_fileheader.jl")
        include("read/read_traceheader.jl")
        include("read/read_trace.jl")
        include("read/read_file.jl")
        include("read/segy_read.jl")

        # Writer
        include("write/write_fileheader.jl")
        include("write/segy_write.jl")
        include("write/write_trace.jl")

        # Scanner
        include("scan/scan_file.jl")
        include("scan/scan_chunk.jl")
        include("scan/scan_block.jl")

     
end # module
