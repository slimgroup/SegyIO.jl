module SeisIO

    #Types
    include("BinaryFileHeader.jl")
    include("BinaryTraceHeader.jl")
    include("IBMFloat32.jl")
    include("read/SeisBlock.jl")
    include("scan/BlockScan.jl")

    #Functions
    include("read/read_fileheader.jl")
    include("read/read_traceheader.jl")
    include("read/read_trace.jl")
    include("read/read_file.jl")
    include("read/segy_read.jl")
    include("scan/scan_file.jl")
    include("scan/scan_chunk.jl")
    include("scan/scan_block.jl")

     
end # module
