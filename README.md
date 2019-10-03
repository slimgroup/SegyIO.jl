# SegyIO.jl
SegyIO is a Julia package for reading and writing SEGY Rev 1 files. In addition to providing tools for reading/writing entire files, SegyIO provides a parallel scanner that reduces any number of files into a single object with direct out-of-core access to the underlying data. 

[![Build Status](https://travis-ci.org/slimgroup/SegyIO.jl.svg?branch=master)](https://travis-ci.org/slimgroup/SegyIO.jl)

A video demonstrating the package's capabilities [has been made available here.](https://www.youtube.com/watch?v=tx530QOPeZo&feature=youtu.be)

## INSTALLATION

### Using SLIM Registry (preferred method) ###

First switch to package manager prompt (using ']') and add SLIM registry:

```
	registry add https://github.com/slimgroup/SLIMregistryJL.git
```

Then still from package manager prompt add SegyIO:

```
	add SegyIO
```

### Adding without SLIM registry ###

After switching to package manager prompt (using ']') type:

```
    add https://github.com/slimgroup/SegyIO.jl.git
```

For more information on reading, writing, and scanning please see the [SegyIO.jl Wiki!](https://github.com/slimgroup/SegyIO.jl/wiki)
