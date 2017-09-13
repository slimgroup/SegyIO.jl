# Test reading component of SeisIO

s = IOBuffer(read(Pkg.dir("SeisIO")*"/src/data/testdata.segy"))

@testset "read" begin

    ##0000
    @testset "read_fileheader" begin
       
        fh = read_fileheader(s)
        @test typeof(fh) == SeisIO.FileHeader 
        @test sizeof(fh.th) == 3200
        @test fh.bfh.ns == 560
        @test fh.bfh.Job == 9999

        fh = read_fileheader(s, ["ns"; "Job"])
        @test typeof(fh) == SeisIO.FileHeader 
        @test sizeof(fh.th) == 3200
        @test fh.bfh.ns == 560
        @test fh.bfh.Job == 9999

        fh = read_fileheader(s, bigendian = false )
        @test typeof(fh) == SeisIO.FileHeader 
        @test sizeof(fh.th) == 3200
        @test fh.bfh.ns == 12290
        @test fh.bfh.Job == 254214144

        fh = read_fileheader(s, ["ns"; "Job"], bigendian = false )
        @test typeof(fh) == SeisIO.FileHeader 
        @test sizeof(fh.th) == 3200
        @test fh.bfh.ns == 12290
        @test fh.bfh.Job == 254214144

    end
    println(" ")

    ##3600
    @testset "read_traceheader" begin

        seek(s, 3600)
        th_b2s = th_byte2sample()

        th = read_traceheader(s, th_b2s)
        @test typeof(th) == BinaryTraceHeader
        @test th.ns == 560
        @test th.SourceX == 11160000
        @test th.GroupX == 11160000

        seek(s, 3600)
        th = read_traceheader(s, ["ns", "SourceX", "GroupX"], th_b2s)
        @test typeof(th) == BinaryTraceHeader
        @test th.ns == 560
        @test th.SourceX == 11160000
        @test th.GroupX == 11160000

        seek(s, 3600)
        th = read_traceheader(s, th_b2s, bigendian = false)
        @test typeof(th) == BinaryTraceHeader
        @test th.ns == 12290
        @test th.SourceX == -1068914176

        seek(s, 3600)
        th = read_traceheader(s, ["ns", "SourceX", "GroupX"], th_b2s, bigendian = false)
        @test typeof(th) == BinaryTraceHeader
        @test th.ns == 12290
        @test th.SourceX == -1068914176

    end

    ##0000
    @testset "read_file" begin

        b = read_file(s, false)
        @test typeof(b) == SeisIO.SeisBlock{SeisIO.IBMFloat32}
        @test b.fileheader.bfh.ns == 560
        @test b.traceheaders[1].ns == 560
        @test size(b.data) == (560, 40000)
        @test length(b.traceheaders) ==  40000
        @test Float32(b.data[100]) == Float32(0)

        b = read_file(s, ["ns"], false)
        @test typeof(b) == SeisIO.SeisBlock{SeisIO.IBMFloat32}
        @test b.fileheader.bfh.ns == 560
        @test b.traceheaders[1].ns == 560
        @test size(b.data) == (560, 40000)
        @test length(b.traceheaders) ==  40000
        @test Float32(b.data[100]) == Float32(0)

    end
end
