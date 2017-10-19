# SeisIO.jl
SeisIO is a Julia package for reading and writing SEGY Rev 1 files. In addition to providing tools for reading/writing entire files, SeisIO provides a parallel scanner that reduces any number of files into a single object with direct out-of-core access to the underlying data. 

A video demonstrating the package's capabilities [has been made available here.](https://www.youtube.com/watch?v=tx530QOPeZo&feature=youtu.be)

## Installation 
SeisIO can be installed using the Julia package manager. If you have a Github account, run the following from the Julia REPL:

    Pkg.clone("git@github.com:slimgroup/SeisIO.jl.git")

Otherwise run:

    Pkg.clone("https://github.com/slimgroup/SeisIO.jl.git")

For more information on reading, writing, and scanning please see the [SeisIO.jl Wiki!](https://github.com/slimgroup/SeisIO.jl/wiki)
