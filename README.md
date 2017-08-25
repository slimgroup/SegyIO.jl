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

    julia> block = SeisIO.segy_read("testdata.segy");

Of course, the file does not need to be in the pwd.

    julia> block = SeisIO.segy_read(Pkg.dir("SeisIO")*"/src/data/testdata.segy");

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

    julia> @elapsed SeisIO.segy_read("testdata.segy", warn_user=false)
    1.492722265

    julia> @elapsed SeisIO.segy_read("testdata.segy", ["SourceX", "SourceY"], warn_user=false)
    0.322848098

SeisIO's performance comes from parsing metadata in memory. This can be toggled using the buffer keyword.

    julia> @elapsed block = segy_read("testdata.segy", warn_user=false, buffer = false)
    33.427740258

    julia> @elapsed block = segy_read("testdata.segy", warn_user=false)
    1.393427409

### Writing

SeisBlocks can be written back onto the disk as a SEGY file using the writer

    julia> segy_write("testwrite.segy", block)
    WARNING: DataSampleFormat not supported for writing. Attempting to convert to IEEE Float32

SeisBlock can currently read data in IBMFloat32(DSF 1) and IEEE Float32 (DSF 5), however it will convert IBMFloat32 data to IEEE Float32 when writing.

If you want to write data as a SEGY file that isn't already in a SeisBlock, simply construct one.

    julia> fh = FileHeader("The writer will pad this to length", BinaryFileHeader())
    julia> fh.bfh.DataSampleFormat = 5
    julia> traceheaders = [BinaryTraceHeader() for i = 1:100]
    julia> block = SeisBlock(fh, traceheaders, zeros(Float32, 1001, 100))
    julia> segy_write("testwrite_custom.segy", block)


