module SeisIO

    #Types
    include("BinaryFileHeader.jl")
    include("BinaryTraceHeader.jl")
    include("IBMFloat32.jl")
    include("read/SeisBlock.jl")

    #Functions
    include("read/read_fileheader.jl")
    include("read/read_traceheader.jl")
    include("read/read_trace.jl")
    include("read/read_file.jl")
     
end # module
