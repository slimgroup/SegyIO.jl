# SeisIO.jl
SeisIO is a Julia package for reading and writing SEGY Rev 1 files. In addition to providing tools for reading/writing entire files, SeisIO provides a parallel scanner that reduces any number of files into a single object with direct out-of-core access to the underlying data. 

[![Build Status](https://travis-ci.org/slimgroup/SeisIO.jl.svg?branch=master)](https://travis-ci.org/slimgroup/SeisIO.jl)

A video demonstrating the package's capabilities [has been made available here.](https://www.youtube.com/watch?v=tx530QOPeZo&feature=youtu.be)

## Installation 
SeisIO can be installed using the Julia package manager. Run the following from the Julia REPL:

```
Pkg.add(PackageSpec(url="https://github.com/slimgroup/SeisIO.jl.git",rev="master"))
```

or with GitHub account (and SSH keys registered) for full developer access:

```
Pkg.develop(PackageSpec(url="git@github.com:slimgroup/SeisIO.jl.git"))
```


For more information on reading, writing, and scanning please see the [SeisIO.jl Wiki!](https://github.com/slimgroup/SeisIO.jl/wiki)
