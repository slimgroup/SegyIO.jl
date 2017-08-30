module SeisIO

    #Types
    include("types/IBMFloat32.jl")
    include("types/BinaryFileHeader.jl")
    include("types/BinaryTraceHeader.jl")
    include("types/FileHeader.jl")
    include("types/SeisBlock.jl")
    include("types/BlockScan.jl")
    include("types/SeisCon.jl")

    #Reader
    include("read/read_fileheader.jl")
    include("read/read_traceheader.jl")
    include("read/read_trace.jl")
    include("read/read_file.jl")
    include("read/segy_read.jl")
    include("read/read_block.jl")
    include("read/read_con.jl")

    # Writer
    include("write/write_fileheader.jl")
    include("write/segy_write.jl")
    include("write/write_trace.jl")

    # Scanner
    include("scan/scan_file.jl")
    include("scan/segy_scan.jl")
    include("scan/scan_chunk.jl")
    include("scan/scan_block.jl")
    include("scan/delim_vector.jl")
    include("scan/find_next_delim.jl")

end # module
