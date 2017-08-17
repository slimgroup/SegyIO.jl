module SeisIO 

    # Functions
    include("read_block.jl")
    include("read_file_header.jl")
    include("delim_vector.jl")
    include("find_next_delim.jl")
    include("bytes_to_samples.jl")

end # module
