module SeisIO

    #Types
    include("BinaryFileHeader.jl")
    include("BinaryTraceHeader.jl")
    include("IBMFloat32.jl")
    include("SeisBlock.jl")

    #Functions
    include("read_fileheader.jl")
    include("read_traceheader.jl")
    include("read_trace.jl")
    include("read_file.jl")
     
end # module
