# SeisIO.jl
SeisIO is a Julia package for reading, writing, and scanning SEGY Rev 1 files. A scanned collection of files returns a SeisCon object, which partitions the volume and provides metadata summaries and direct access to all files.

## Installation 
SeisIO can be installed using the Julia package manager. If you have a Github account, run the following from the Julia REPL:

    Pkg.clone("git@github.com:slimgroup/SeisIO.jl.git")

Otherwise run:

    Pkg.clone("https://github.com/slimgroup/SeisIO.jl.git")


## Scanning
-----

Example data has been provided with the package in src/data/

### Introduction
A scanned volume provides a higher level of abstraction, removing the need for a user to directly manage individual files. Scanning a file (or a group of files) returns a `SeisCon` object, which contains the necessary information to partition the volume into more managable pieces and directly access these partitions. By default, the scanner will automatically partition the volume when the source location changes.

The `/src/data/` directory contains 4 SEGY files generated from the Overthrust model, each containing roughly 20 shots. Scanning these 4 files into a `SeisCon` object will allow direct access to these shots without duplicating any memory.

    julia> using SeisIO

    julia> dir2scan = Pkg.dir("SeisIO")*"/src/data/"
    "/home/slim/klensink/.julia/v0.6/SeisIO/src/data/"

    julia> file_filter = "overthrust"
    "overthrust"

    julia> keys = ["GroupX"; "GroupY"]
    2-element Array{String,1}:
     "GroupX"
     "GroupY"

    julia> s = segy_scan(dir2scan, file_filter, keys);
    Scanning ... SeisIO/src/data/overthrust_2D_shot_1_20.segy
    Scanning ... SeisIO/src/data/overthrust_2D_shot_21_40.segy
    Scanning ... SeisIO/src/data/overthrust_2D_shot_41_60.segy
    Scanning ... SeisIO/src/data/overthrust_2D_shot_61_80.segy
    Scanning ... SeisIO/src/data/overthrust_2D_shot_81_97.segy

    julia> length(s)
    97

### SeisCon Objects
At the core of the `SeisCon` object, `s`, is a vector of `BlockScan` objects. Each `BlockScan` contains a metadata summary for each partition. Only the header fields defined in `keys` are summarized.

The scanner automatically detected 97 shots, and created metadata summaries for all traces in each shot.

The first three fields contain the file path, the start byte, and end byte of the partition. The last field is a dictionary containing the minimum and maximum value for each `key` within the partition.

    julia> s.blocks[1]
    SeisIO.BlockScan(".../SeisIO/src/data/overthrust_2D_shot_1_20.segy", 3600, 415588, Dict("SourceX"=>Int32[400, 400],"SourceY"=>Int32[0, 0],"GroupX"=>Int32[100, 6400],"GroupY"=>Int32[0, 0]))

    julia> fieldnames(BlockScan)
    4-element Array{Symbol,1}:
     :file     
     :startbyte
     :endbyte  
     :summary 

`get_sources` and `get_header` can be used to inspect these summaries for an entire `SeisCon` object.

    julia> src_locations = get_sources(s)
    97×2 Array{Int32,2}:
      400  0
      600  0
      800  0
        ⋮
    19200  0
    19400  0
    19600  0

The data referenced in in a `BlockScan` can be accessed by indexing the `SeisCon` object.

    julia> d = s[1];

The combination of metadata summaries and direct access allows the user to easily perform operations that would otherwise be quite tedious. For example, let's load every trace where the source was located between gridpoints 5000 and 10000.

    julia> d = s[find(x -> 5000<= x <=10000, src_locations[:,1])] 

### Distributed Scanning
By default, `segy_scan` distributes files queued for scanning to all workers in order to parallelize scanning.

    julia> addprocs(4)
    4-element Array{Int64,1}:
     2
     3
     4
     5

    julia> @everywhere using SeisIO

    julia> dir2scan = Pkg.dir("SeisIO")*"/src/data/"
    "/home/slim/klensink/.julia/v0.6/SeisIO/src/data/"

    julia> file_filter = "overthrust"
    "overthrust"

    julia> keys = ["GroupX"; "GroupY"]
    2-element Array{String,1}:
     "GroupX"
     "GroupY"
    
    julia> s = segy_scan(dir2scan, file_filter, keys);
        From worker 2:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_1_20.segy
        From worker 4:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_41_60.segy
        From worker 3:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_21_40.segy
        From worker 5:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_61_80.segy
        From worker 2:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_81_97.segy

The optional keyword argument `pool` can be set to define a different worker pool to distribute across.

    julia> s = segy_scan(dir2scan, file_filter, keys, pool = WorkerPool(workers()[1:2]));
        From worker 2:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_1_20.segy
        From worker 3:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_21_40.segy
        From worker 2:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_41_60.segy
        From worker 3:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_61_80.segy
        From worker 2:  Scanning ... /SeisIO/src/data/overthrust_2D_shot_81_97.segy

### Chunking 

Inorder to scan files larger than memory, the scanner reads `chunksize` MB of data into an IOBuffer at a time inorder to process the data in memory. This allows the scanner to scale to any file size, and has the added benefit of reducing the number of calls to read from the disk.  

The default `chunksize` is 1024 MB, and can be modified using the `chunksize` keyword argument in `segy_scan`. Increasing `chunksize` yields moderate performance gains at the expensive of increased peak memory.

    julia> @time s = segy_scan(dir2scan, file_filter, keys);
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_1_20.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_21_40.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_41_60.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_61_80.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_81_97.segy
      0.077360 seconds (384.77 k allocations: 5.013 GiB, 10.37% gc time)

    julia> @time s = segy_scan(dir2scan, file_filter, keys, chunksize = 10);
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_1_20.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_21_40.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_41_60.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_61_80.segy
    Scanning ... /home/slim/klensink/.julia/v0.6/SeisIO/src/data/overthrust_2D_shot_81_97.segy
      0.110804 seconds (385.64 k allocations: 103.844 MiB, 4.85% gc time)

## Reading
-----

First start up Julia, load the package, and move into the directory storing the example SEGY file.
    
    julia> using SeisIO
    julia> cd(Pkg.dir("SeisIO")*"/src/data/")

Reading a file is a simple as passing the file path to the reader

    julia> block = segy_read("testdata.segy");

Of course, the file does not need to be in the pwd.

    julia> block = segy_read(Pkg.dir("SeisIO")*"/src/data/testdata.segy");

SeisIO currently requires fixed trace length (this will be changing soon), and will warn if the fixed trace length flag is not set in the file header.

The reader returns the contents of the SEGY file in a *SeisBlock* composite type. This type contains:
* The FileHeader, containing the textual and binary file headers
* A vector of BinaryTraceHeaders, one for each trace
* The trace data collected into an array (nsamples *x* ntraces)

Show methods for BinaryTraceHeaders and FileHeaders are provided

    julia> block.fileheader
    BinaryFileHeader:
                                Job:      9999
                               Line:      9999
                               Reel:         1
               DataTracePerEnsemble:       400
          AuxiliaryTracePerEnsemble:         0
                                 dt:      4000
                             dtOrig:      4000
                                 ns:       560
                             nsOrig:       560
                   DataSampleFormat:         1
                       EnsembleFold:    -13922
                       TraceSorting:         4
                    VerticalSumCode:         1
                SweepFrequencyStart:         0
                  SweepFrequencyEnd:         0
                        SweepLength:         0
                          SweepType:         0
                       SweepChannel:         0
              SweepTaperlengthStart:         0
                SweepTaperLengthEnd:         0
                          TaperType:         0
               CorrelatedDataTraces:         2
                         BinaryGain:         1
            AmplitudeRecoveryMethod:         4
                  MeasurementSystem:         2
              ImpulseSignalPolarity:         0
              VibratoryPolarityCode:         0
           SegyFormatRevisionNumber:         0
               FixedLengthTraceFlag:         0
          NumberOfExtTextualHeaders:         0

SeisIO provides the option of reading only user-specified BinaryTraceHeader values from disk. This allows the reader to only focus on what matters, and can improve performance considerably. 

    julia> @elapsed segy_read("testdata.segy", warn_user=false)
    1.492722265

    julia> @elapsed segy_read("testdata.segy", ["SourceX", "SourceY"], warn_user=false)
    0.322848098

SeisIO's performance comes from parsing metadata in memory. This can be toggled using the buffer keyword.

    julia> @elapsed block = segy_read("testdata.segy", warn_user=false, buffer = false)
    33.427740258
 
    julia> @elapsed block = segy_read("testdata.segy", warn_user=false)
    1.393427409

To get all values of a BinaryTraceHeader field for an entire block, use **get_header**

    julia> sx = get_header(block, "SourceX")
    julia> sy = get_header(block, :SourceY)
    julia> typeof(sx)
    Array{Int32,1}

The header field values are returned in a vector, trace order is preserved.

## Writing
-----

SeisBlocks can be written back onto the disk as a SEGY file using the writer

    julia> segy_write("testwrite.segy", block)
    WARNING: DataSampleFormat not supported for writing. Attempting to convert to IEEE Float32

SeisBlock can currently read data in IBMFloat32(DSF 1) and IEEE Float32 (DSF 5), however it will convert IBMFloat32 data to IEEE Float32 when writing.

### Constructing a SeisBlock
If the data you want to save as a SEGY file is just an array in memory, you will need to put it into a SeisBlock before you can write it. Passing a 2D array to the SeisBlock constructor will return a bare-bones SeisBlock instance, where all the headers value are zero except for the number of samples and data sample format, which are inferred from the array.

    julia> data = zeros(Float32, 1000, 100)
    julia> block = SeisBlock(data)

Use **set_headers!** to populate the blocks headers with the desired metadata. Header fields can be passed as either strings or symbols.

    julia> set_header!(block, "dt", 8000)

If a value is the same for all traceheaders, you can pass a scalar.

    julia> set_header!(block, :SourceX, 100)
    julia> set_header!(block, :SourceY, 100)

Or if the value varies, pass a vector with length *ntraces*.

    julia> set_header!(block, :GroupX, Array(1:100))
    julia> set_header!(block, :GroupY, Array(1:100))

If a chosen field is present in both BinaryFileHeaders and BinaryTraceHeaders, both will be set.

    d = s[find(x -> 5000<x<10000, src_locations[:,1])]
