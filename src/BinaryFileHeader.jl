export BinaryFileHeader

type BinaryFileHeader
    jobid  :: Int32
    linnum :: Int32
    renum  :: Int32
    ntrpe  :: Int16
    natrpe :: Int16
    dt     :: Int16
    dtfr   :: Int16
    ns     :: Int16
    nsfr   :: Int16
    dsf    :: Int16
    expf   :: Int16
    trsc   :: Int16
    vsumc  :: Int16
    sfs    :: Int16
    sfe    :: Int16
    slen   :: Int16
    styp   :: Int16
    tnumsc :: Int16
    stalens:: Int16
    stalene:: Int16
    tyta   :: Int16
    corr   :: Int16
    rgc    :: Int16
    arm    :: Int16
    unit   :: Int16
    pol    :: Int16
    vpol   :: Int16
    fvn    :: Int16
    fltf   :: Int16
    netfh  :: Int16
    fh_byte2sample :: Dict{String,Int}
end 

function BinaryFileHeader()

   BinaryFileHeader(0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,0,0, 
                    fh_bytes2samples())

end

function fh_bytes2samples()

    Dict{String, Int32}(
        "jobid"   => 3200,
        "linnum"  => 3204,
        "renum"   => 3208,
        "ntrpe"   => 3212,
        "natrpe"  => 3214,
        "dt"      => 3216,
        "dtfr"    => 3218,
        "ns"      => 3220,
        "nsfr"    => 3222,
        "dsf"     => 3224,
        "expf"    => 3226,
        "trsc"    => 3228,
        "vsumc"   => 3230,
        "sfs"     => 3232,
        "sfe"     => 3234,
        "slen"    => 3236,
        "styp"    => 3238,
        "tnumsc"  => 3240,
        "stalens" => 3242,
        "stalene" => 3244,
        "tyta"    => 3246,
        "corr"    => 3248,
        "rgc"     => 3250,
        "arm"     => 3252,
        "unit"    => 3254,
        "pol"     => 3256,
        "vpol"    => 3258,
        "fvn"     => 3500,
        "fltf"    => 3502,
        "netfh"   => 3504)

end
