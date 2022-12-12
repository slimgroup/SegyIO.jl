# SegyIO.jl

SegyIO is a Julia package for reading and writing SEGY Rev 1 files. In addition to providing tools for reading/writing entire files, SegyIO provides a parallel scanner that reduces any number of files into a single object with direct out-of-core access to the underlying data. 

[![Build Status](https://github.com/slimgroup/SegyIO.jl/workflows/CI-tests/badge.svg)](https://github.com/slimgroup/SegyIO.jl/actions?query=workflow%3ACI-tests)

A video demonstrating the package's capabilities [has been made available here.](https://www.youtube.com/watch?v=tx530QOPeZo&feature=youtu.be)

## INSTALLATION

SegyIO is a registered package and can be installed directly from the julia package manager (`]` in the julia REPL) :

```
 add SegyIO
```

## Extension

SegyIO is implemented for POSIX systems. For Cloud storage, use [CloudSegyIO.jl](https://github.com/slimgroup/CloudSegyIO.jl), the Cloud storage extension of SegyIO.
