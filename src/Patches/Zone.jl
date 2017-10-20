import Base.getindex
export Zone, makezone, getindex

struct Zone
    patchfiles::Vector{String}
    headerfile::String
    pathtofiles::String
    id::Tuple{Integer, Integer}
end

function makezone(s::SeisCon, pathtowrite::String, id::Tuple{Int, Int};
                                    inds = 1:Int(1+floor(s.ns/2)),
                                    transform::Function = rfft)
    
    endswith(pathtowrite, "/") ? nothing : pathtowrite *= "/"

    # Make patches from block
    block = s[1] 
    p, h = makepatches(block, id, inds, transform)
    
    # Store to disk
    headername = @sprintf "headers_%09d_%09d.jld" id[1] id[2]
    save(pathtowrite*headername, "headers", h, "id", id)

    patchname = Array{String}(length(p))
    i = 1
    for patch in p
        patchname[i] = @sprintf "patch_%09d_%09d_%09d.jld" patch.id[1] patch.id[2] patch.id[3]
        save(pathtowrite*patchname[i], "patch", patch)
        i+=1
    end

    return Zone(patchname, headername, pathtowrite, id)
    
end

function getindex(z::Zone, i::Integer; headers::Bool = true)
    p = load(z.pathtofiles*z.patchfiles[i], "patch")

    if headers;
        h = load(z.pathtofiles*z.headerfile, "headers")
        return p, h
    end

    return p
end
