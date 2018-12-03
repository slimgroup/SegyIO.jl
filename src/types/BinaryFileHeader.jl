import Base.show

export BinaryFileHeader, fh_byte2sample, show

mutable struct BinaryFileHeader
    Job                                  :: Int32
    Line                                 :: Int32
    Reel                                 :: Int32
    DataTracePerEnsemble                 :: Int16
    AuxiliaryTracePerEnsemble            :: Int16
    dt                                   :: Int16
    dtOrig                               :: Int16
    ns                                   :: Int16
    nsOrig                               :: Int16
    DataSampleFormat                     :: Int16
    EnsembleFold                         :: Int16
    TraceSorting                         :: Int16
    VerticalSumCode                      :: Int16
    SweepFrequencyStart                  :: Int16
    SweepFrequencyEnd                    :: Int16
    SweepLength                          :: Int16
    SweepType                            :: Int16
    SweepChannel                         :: Int16
    SweepTaperlengthStart                :: Int16
    SweepTaperLengthEnd                  :: Int16
    TaperType                            :: Int16
    CorrelatedDataTraces                 :: Int16
    BinaryGain                           :: Int16
    AmplitudeRecoveryMethod              :: Int16
    MeasurementSystem                    :: Int16
    ImpulseSignalPolarity                :: Int16
    VibratoryPolarityCode                :: Int16
    SegyFormatRevisionNumber             :: Int16
    FixedLengthTraceFlag                 :: Int16
    NumberOfExtTextualHeaders            :: Int16
end

function BinaryFileHeader()

   BinaryFileHeader(0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0)

end

function fh_byte2sample()

    Dict{String, Int32}(
        "Job"                               => 3200,
        "Line"                              => 3204,
        "Reel"                              => 3208,
        "DataTracePerEnsemble"              => 3212,
        "AuxiliaryTracePerEnsemble"         => 3214,
        "dt"                                => 3216,
        "dtOrig"                            => 3218,
        "ns"                                => 3220,
        "nsOrig"                            => 3222,
        "DataSampleFormat"                  => 3224,
        "EnsembleFold"                      => 3226,
        "TraceSorting"                      => 3228,
        "VerticalSumCode"                   => 3230,
        "SweepFrequencyStart"               => 3232,
        "SweepFrequencyEnd"                 => 3234,
        "SweepLength"                       => 3236,
        "SweepType"                         => 3238,
        "SweepChannel"                      => 3240,
        "SweepTaperlengthStart"             => 3242,
        "SweepTaperLengthEnd"               => 3244,
        "TaperType"                         => 3246,
        "CorrelatedDataTraces"              => 3248,
        "BinaryGain"                        => 3250,
        "AmplitudeRecoveryMethod"           => 3252,
        "MeasurementSystem"                 => 3254,
        "ImpulseSignalPolarity"             => 3256,
        "VibratoryPolarityCode"             => 3258,
        "SegyFormatRevisionNumber"          => 3500,
        "FixedLengthTraceFlag"              => 3502,
        "NumberOfExtTextualHeaders"         => 3504)
end

function show(io::IO, bfh::BinaryFileHeader)
    
    println("BinaryFileHeader:")

    for field in fieldnames(BinaryFileHeader)
        s = @sprintf "     %30s: %9d" String(field) getfield(bfh, field)
        println(s)
    end
    println("\n")
end
