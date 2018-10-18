## From JuliaSeis
primitive type IBMFloat32 32 end

ieeeOfPieces(fr::UInt32, exp::Int32, sgn::UInt32) = 
    reinterpret(Float32, convert(UInt32,fr >>> 9) | convert(UInt32,exp << 23) | sgn) :: Float32

import Base.convert, Base.Float32

function convert(::Type{Float32}, ibm::IBMFloat32)
    local fr::UInt32 = ntoh(reinterpret(UInt32, ibm))
    local sgn::UInt32 = fr & 0x80000000 # save sign
    fr <<= 1 # shift sign out
    local exp::Int32 = convert(Int32,fr >>> 25) # save exponent
    fr <<= 7 # shift exponent out

    if (fr == convert(UInt32,0))
        zero(Float32)
    else
        # normalize the signficand
        local norm::UInt32 = leading_zeros(fr)
        fr <<= norm
        exp = (exp << 2) - 130 - norm
        # exp <= 0 --> ieee(0,0,sgn)
        # exp >= 255 --> ieee(0,255,sgn)
        # else -> ieee(fr<<1, exp, sgn)
        local clexp::Int32 = exp & convert(Int32,0xFF)
        ieeeOfPieces(clexp == exp ? fr << 1 : convert(UInt32,0), clexp, sgn)
    end
end
Float32(ibm::IBMFloat32) = convert(Float32,ibm)
## From JuliaSeis
