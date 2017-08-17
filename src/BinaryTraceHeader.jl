export BinaryTraceHeader

type BinaryTraceHeader
    tracl::Int32
    tracr::Int32
    fldr::Int32
    tracf::Int32
    ep::Int32
    cdp::Int32
    cdpt::Int32
    trid::Int16
    nva::Int16
    nhs::Int16
    duse::Int16
    offset::Int32
    gelev::Int32
    selev::Int32
    sdepth::Int32
    gdel::Int32
    sdel::Int32
    swdep::Int32
    gwdep::Int32
    scalel::Int16
    scalco::Int16
    sx::Int32
    sy::Int32
    gx::Int32
    gy::Int32
    counit::Int16
    wevel::Int16
    swevel::Int16
    sut::Int16
    gut::Int16
    sstat::Int16
    gstat::Int16
    tstat::Int16
    laga::Int16
    lagb::Int16
    delrt::Int16
    muts::Int16
    mute::Int16
    ns::Int16
    dt::Int16
    gain::Int16
    igc::Int16
    igi::Int16
    corr::Int16
    sfs::Int16
    sfe::Int16
    slen::Int16
    styp::Int16
    stas::Int16
    stae::Int16
    tatyp::Int16
    afilf::Int16
    afils::Int16
    nofilf::Int16
    nofils::Int16
    lcf::Int16
    hcf::Int16
    lcs::Int16
    hcs::Int16
    year::Int16
    day::Int16
    hour::Int16
    minute::Int16
    sec::Int16
    timbas::Int16
    trwf::Int16
    grnors::Int16
    grnofr::Int16
    grnlof::Int16
    gaps::Int16
    otrav::Int16
    d1::Float32
    f1::Float32
    d2::Float32
    f2::Float32
    ungpow::Float32
    unscale::Float32
    ntr::Int32
    mark::Int16
    unass::Int16
    th_byte2sample::Dict{String, Int32}
end

function th_byte2sample()
    Dict{String,Int32}(
        "tracl"    =>  0  ,
        "tracr"    =>  4  ,
        "fldr"     =>  8  ,
        "tracf"    =>  12 ,
        "ep"       =>  16 ,
        "cdp"      =>  20 ,
        "cdpt"     =>  24 ,
        "trid"     =>  28 ,
        "nva"      =>  30 ,
        "nhs"      =>  32 ,
        "duse"     =>  34 ,
        "offset"   =>  36 ,
        "gelev"    =>  40 ,
        "selev"    =>  44 ,
        "sdepth"   =>  48 ,
        "gdel"     =>  52 ,
        "sdel"     =>  56 ,
        "swdep"    =>  60 ,
        "gwdep"    =>  64 ,
        "scalel"   =>  68 ,
        "scalco"   =>  70 ,
        "sx"       =>  72 ,
        "sy"       =>  76 ,
        "gx"       =>  80 ,
        "gy"       =>  84 ,
        "counit"   =>  88 ,
        "wevel"    =>  90 ,
        "swevel"   =>  92 ,
        "sut"      =>  94 ,
        "gut"      =>  96 ,
        "sstat"    =>  98 ,
        "gstat"    =>  100,
        "tstat"    =>  102,
        "laga"     =>  104,
        "lagb"     =>  106,
        "delrt"    =>  108,
        "muts"     =>  110,
        "mute"     =>  112,
        "ns"       =>  114,
        "dt"       =>  116,
        "gain"     =>  118,
        "igc"      =>  120,
        "igi"      =>  122,
        "corr"     =>  124,
        "sfs"      =>  126,
        "sfe"      =>  128,
        "slen"     =>  130,
        "styp"     =>  132,
        "stas"     =>  134,
        "stae"     =>  136,
        "tatyp"    =>  138,
        "afilf"    =>  140,
        "afils"    =>  142,
        "nofilf"   =>  144,
        "nofils"   =>  146,
        "lcf"      =>  148,
        "hcf"      =>  150,
        "lcs"      =>  152,
        "hcs"      =>  154,
        "year"     =>  156,
        "day"      =>  158,
        "hour"     =>  160,
        "minute"   =>  162,
        "sec"      =>  164,
        "timbas"   =>  166,
        "trwf"     =>  168,
        "grnors"   =>  170,
        "grnofr"   =>  172,
        "grnlof"   =>  174,
        "gaps"     =>  176,
        "otrav"    =>  178,
        "d1"       =>  180,
        "f1"       =>  184,
        "d2"       =>  188,
        "f2"       =>  192,
        "ungpow"   =>  196,
        "unscale"  =>  200,
        "ntr"      =>  204,
        "mark"     =>  208,
        "unass"    =>  210)
end

function BinaryTraceHeader()
    BinaryTraceHeader(0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,0,0,
    th_byte2sample())
end
