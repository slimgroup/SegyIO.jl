# SeisIO.jl
SeisIO is a Julia package for reading and writing SEGY Rev 1 files. 

## Installation 
SeisIO can be installed using the Julia package manager. If you have a Github account, run the following from the Julia REPL:

    Pkg.clone("git@github.com:slimgroup/SeisIO.jl.git")

Otherwise run:

    Pkg.clone("https://github.com/slimgroup/SeisIO.jl.git")

## Examples
Example data has been provided with the package in src/data/

### Reading
First start up Julia, load the package, and move into the directory storing the example SEGY file.
    
    julia
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

### Writing

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


