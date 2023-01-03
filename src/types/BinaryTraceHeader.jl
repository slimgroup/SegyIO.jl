export BinaryTraceHeader, th_byte2sample

mutable struct BinaryTraceHeader
    TraceNumWithinLine                 ::Int32
    TraceNumWithinFile                 ::Int32
    FieldRecord                        ::Int32
    TraceNumber                        ::Int32
    EnergySourcePoint                  ::Int32
    CDP                                ::Int32
    CDPTrace                           ::Int32
    TraceIDCode                        ::Int16
    NSummedTraces                      ::Int16
    NStackedTraces                     ::Int16
    DataUse                            ::Int16
    Offset                             ::Int32
    RecGroupElevation                  ::Int32
    SourceSurfaceElevation             ::Int32
    SourceDepth                        ::Int32
    RecDatumElevation                  ::Int32
    SourceDatumElevation               ::Int32
    SourceWaterDepth                   ::Int32
    GroupWaterDepth                    ::Int32
    ElevationScalar                    ::Int16
    RecSourceScalar                    ::Int16
    SourceX                            ::Int32
    SourceY                            ::Int32
    GroupX                             ::Int32
    GroupY                             ::Int32
    CoordUnits                         ::Int16
    WeatheringVelocity                 ::Int16
    SubWeatheringVelocity              ::Int16
    UpholeTimeSource                   ::Int16
    UpholeTimeGroup                    ::Int16
    StaticCorrectionSource             ::Int16
    StaticCorrectionGroup              ::Int16
    TotalStaticApplied                 ::Int16
    LagTimeA                           ::Int16
    LagTimeB                           ::Int16
    DelayRecordingTime                 ::Int16
    MuteTimeStart                      ::Int16
    MuteTimeEnd                        ::Int16
    ns                                 ::Int16
    dt                                 ::Int16
    GainType                           ::Int16
    InstrumentGainConstant             ::Int16
    InstrumntInitialGain               ::Int16
    Correlated                         ::Int16
    SweepFrequencyStart                ::Int16
    SweepFrequencyEnd                  ::Int16
    SweepLength                        ::Int16
    SweepType                          ::Int16
    SweepTraceTaperLengthStart         ::Int16
    SweepTraceTaperLengthEnd           ::Int16
    TaperType                          ::Int16
    AliasFilterFrequency               ::Int16
    AliasFilterSlope                   ::Int16
    NotchFilterFrequency               ::Int16
    NotchFilterSlope                   ::Int16
    LowCutFrequency                    ::Int16
    HighCutFrequency                   ::Int16
    LowCutSlope                        ::Int16
    HighCutSlope                       ::Int16
    Year                               ::Int16
    DayOfYear                          ::Int16
    HourOfDay                          ::Int16
    MinuteOfHour                       ::Int16
    SecondOfMinute                     ::Int16
    TimeCode                           ::Int16
    TraceWeightingFactor               ::Int16
    GeophoneGroupNumberRoll            ::Int16
    GeophoneGroupNumberTraceStart      ::Int16
    GeophoneGroupNumberTraceEnd        ::Int16
    GapSize                            ::Int16
    OverTravel                         ::Int16
    CDPX                               ::Int32
    CDPY                               ::Int32
    Inline3D                           ::Int32
    Crossline3D                        ::Int32
    ShotPoint                          ::Int32
    ShotPointScalar                    ::Int16
    TraceValueMeasurmentUnit           ::Int16
    TransductionConstnatMantissa       ::Int32
    TransductionConstantPower          ::Int16
    TransductionUnit                   ::Int16
    TraceIdentifier                    ::Int16
    ScalarTraceHeader                  ::Int16
    SourceType                         ::Int16
    SourceEnergyDirectionMantissa      ::Int32
    SourceEnergyDirectionExponent      ::Int16
    SourceMeasurmentMantissa           ::Int32
    SourceMeasurementExponent          ::Int16
    SourceMeasurmentUnit               ::Int16
    Unassigned1                        ::Int32
    Unassigned2                        ::Int32
end

function th_byte2sample()
    Dict{String, Int32}(
        "TraceNumWithinLine"              =>  1  -1,
        "TraceNumWithinFile"              =>  5  -1,
        "FieldRecord"                     =>  9  -1,
        "TraceNumber"                     =>  13 -1,
        "EnergySourcePoint"               =>  17 -1,
        "CDP"                             =>  21 -1,
        "CDPTrace"                        =>  25 -1,
        "TraceIDCode"                     =>  29 -1,
        "NSummedTraces"                   =>  31 -1,
        "NStackedTraces"                  =>  33 -1,
        "DataUse"                         =>  35 -1,
        "Offset"                          =>  37 -1,
        "RecGroupElevation"               =>  41 -1,
        "SourceSurfaceElevation"          =>  45 -1,
        "SourceDepth"                     =>  49 -1,
        "RecDatumElevation"               =>  53 -1,
        "SourceDatumElevation"            =>  57 -1,
        "SourceWaterDepth"                =>  61 -1,
        "GroupWaterDepth"                 =>  65 -1,
        "ElevationScalar"                 =>  69 -1,
        "RecSourceScalar"                 =>  71 -1,
        "SourceX"                         =>  73 -1,
        "SourceY"                         =>  77 -1,
        "GroupX"                          =>  81 -1,
        "GroupY"                          =>  85 -1,
        "CoordUnits"                      =>  89 -1,
        "WeatheringVelocity"              =>  91 -1,
        "SubWeatheringVelocity"           =>  93 -1,
        "UpholeTimeSource"                =>  95 -1,
        "UpholeTimeGroup"                 =>  97 -1,
        "StaticCorrectionSource"          =>  99 -1,
        "StaticCorrectionGroup"           =>  101-1,
        "TotalStaticApplied"              =>  103-1,
        "LagTimeA"                        =>  105-1,
        "LagTimeB"                        =>  107-1,
        "DelayRecordingTime"              =>  109-1,
        "MuteTimeStart"                   =>  111-1,
        "MuteTimeEnd"                     =>  113-1,
        "ns"                              =>  115-1,
        "dt"                              =>  117-1,
        "GainType"                        =>  119-1,
        "InstrumentGainConstant"          =>  121-1,
        "InstrumntInitialGain"            =>  123-1,
        "Correlated"                      =>  125-1,
        "SweepFrequencyStart"             =>  127-1,
        "SweepFrequencyEnd"               =>  129-1,
        "SweepLength"                     =>  131-1,
        "SweepType"                       =>  133-1,
        "SweepTraceTaperLengthStart"      =>  135-1,
        "SweepTraceTaperLengthEnd"        =>  137-1,
        "TaperType"                       =>  139-1,
        "AliasFilterFrequency"            =>  141-1,
        "AliasFilterSlope"                =>  143-1,
        "NotchFilterFrequency"            =>  145-1,
        "NotchFilterSlope"                =>  147-1,
        "LowCutFrequency"                 =>  149-1,
        "HighCutFrequency"                =>  151-1,
        "LowCutSlope"                     =>  153-1,
        "HighCutSlope"                    =>  155-1,
        "Year"                            =>  157-1,
        "DayOfYear"                       =>  159-1,
        "HourOfDay"                       =>  161-1,
        "MinuteOfHour"                    =>  163-1,
        "SecondOfMinute"                  =>  165-1,
        "TimeCode"                        =>  167-1,
        "TraceWeightingFactor"            =>  169-1,
        "GeophoneGroupNumberRoll"         =>  171-1,
        "GeophoneGroupNumberTraceStart"   =>  173-1,
        "GeophoneGroupNumberTraceEnd"     =>  175-1,
        "GapSize"                         =>  177-1,
        "OverTravel"                      =>  179-1,
        "CDPX"                            =>  181-1,
        "CDPY"                            =>  185-1,
        "Inline3D"                        =>  189-1,
        "Crossline3D"                     =>  193-1,
        "ShotPoint"                       =>  197-1,
        "ShotPointScalar"                 =>  201-1,
        "TraceValueMeasurmentUnit"        =>  203-1,
        "TransductionConstnatMantissa"    =>  205-1,
        "TransductionConstantPower"       =>  209-1,
        "TransductionUnit"                =>  211-1,
        "TraceIdentifier"                 =>  213-1,
        "ScalarTraceHeader"               =>  215-1,
        "SourceType"                      =>  217-1,
        "SourceEnergyDirectionMantissa"   =>  219-1,
        "SourceEnergyDirectionExponent"   =>  223-1,
        "SourceMeasurmentMantissa"        =>  225-1,
        "SourceMeasurementExponent"       =>  229-1,
        "SourceMeasurmentUnit"            =>  231-1,
        "Unassigned1"                     =>  233-1,
        "Unassigned2"                     =>  237-1)

end

th_keys() = collect(keys(th_byte2sample()))

function BinaryTraceHeader()
    BinaryTraceHeader(0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,0)
end

Base.zeros(::Type{BinaryTraceHeader}, n::Integer) = [BinaryTraceHeader() for _=1:n]

function show(io::IO, bth::BinaryTraceHeader)
    
    println("BinaryTraceHeader:")
    for field in fieldnames(BinaryTraceHeader)
        s = @sprintf "     %30s: %9d" String(field) getfield(bth, field)
        println(s)
    end
    println("\n")

end

function show(io::IO, Abth::Array{BinaryTraceHeader,1})
    

    if length(Abth) == 0
        println("Empty Traceheaders")
    else
        # Show first
        println("BinaryTraceHeader 1:")
        for field in fieldnames(BinaryTraceHeader)
            s = @sprintf "     %30s: %9d" String(field) getfield(Abth[1], field)
            println(s)
        end
        
        println("\n ... \n")

        # Show last
        println("BinaryTraceHeader $(length(Abth)):")
        for field in fieldnames(BinaryTraceHeader)
            s = @sprintf "     %30s: %9d" String(field) getfield(Abth[end], field)
            println(s)
        end
    end
end
