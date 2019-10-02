# SegyIO.jl
SegyIO is a Julia package for reading and writing SEGY Rev 1 files. In addition to providing tools for reading/writing entire files, SegyIO provides a parallel scanner that reduces any number of files into a single object with direct out-of-core access to the underlying data. 

A video demonstrating the package's capabilities [has been made available here.](https://www.youtube.com/watch?v=tx530QOPeZo&feature=youtu.be)

## Installation 
SegyIO can be installed using the Julia package manager. If you have a Github account, run the following from the Julia REPL:

    Pkg.clone("git@github.com:slimgroup/SegyIO.jl.git")

Otherwise run:

    Pkg.clone("https://github.com/slimgroup/SegyIO.jl.git")

For more information on reading, writing, and scanning please see the [SegyIO.jl Wiki!](https://github.com/slimgroup/SegyIO.jl/wiki)
