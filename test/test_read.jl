# Test reading component of SeisIO

s = IOBuffer(read(Pkg.dir("SeisIO")*"/src/data/overthrust_2D_shot_1_20.segy"))

@testset "Read" begin
    @testset "Read -- Unit Tests" begin

        # Byte 0000
        @testset "read_fileheader" begin
           
            fh = read_fileheader(s)
            @test typeof(fh) == SeisIO.FileHeader 
            @test sizeof(fh.th) == 3200
            @test fh.bfh.ns == 751
            @test fh.bfh.Job == 1

            fh = read_fileheader(s, ["ns"; "Job"])
            @test typeof(fh) == SeisIO.FileHeader 
            @test sizeof(fh.th) == 3200
            @test fh.bfh.ns == 751
            @test fh.bfh.Job == 1

            fh = read_fileheader(s, bigendian = false )
            @test typeof(fh) == SeisIO.FileHeader 
            @test sizeof(fh.th) == 3200
            @test fh.bfh.ns == -4350
            @test fh.bfh.Job == 16777216

            fh = read_fileheader(s, ["ns"; "Job"], bigendian = false )
            @test typeof(fh) == SeisIO.FileHeader 
            @test sizeof(fh.th) == 3200
            @test fh.bfh.ns == -4350
            @test fh.bfh.Job == 16777216

        end

        # Byte 3600
        @testset "read_traceheader" begin

            seek(s, 3600)
            th_b2s = th_byte2sample()

            th = read_traceheader(s, th_b2s)
            @test typeof(th) == BinaryTraceHeader
            @test th.ns == 751
            @test th.SourceX == 400
            @test th.GroupX == 100

            seek(s, 3600)
            th = read_traceheader(s, ["ns", "SourceX", "GroupX"], th_b2s)
            @test typeof(th) == BinaryTraceHeader
            @test th.ns == 751
            @test th.SourceX == 400
            @test th.GroupX == 100

            seek(s, 3600)
            th = read_traceheader(s, th_b2s, bigendian = false)
            @test typeof(th) == BinaryTraceHeader
            @test th.ns == -4350
            @test th.SourceX == -1878982656

            seek(s, 3600)
            th = read_traceheader(s, ["ns", "SourceX", "GroupX"], th_b2s, bigendian = false)
            @test typeof(th) == BinaryTraceHeader
            @test th.ns == -4350
            @test th.SourceX == -1878982656
        end
    end

    @testset "Read -- Integration Tests" begin
        
        # 0000
        @testset "read_file" begin

            b = read_file(s, false)
            @test typeof(b) == SeisIO.SeisBlock{SeisIO.IBMFloat32}
            @test b.fileheader.bfh.ns == 751
            @test b.traceheaders[1].ns == 751
            @test size(b.data) == (751, 3300)
            @test length(b.traceheaders) ==  3300
            @test Float32(b.data[100]) == -2.2972927f0

            b = read_file(s, ["ns"], false)
            @test typeof(b) == SeisIO.SeisBlock{SeisIO.IBMFloat32}
            @test b.fileheader.bfh.ns == 751
            @test b.traceheaders[1].ns == 751
            @test size(b.data) == (751, 3300)
            @test length(b.traceheaders) ==  3300
            @test Float32(b.data[100]) == -2.2972927f0

        end

        @testset "segy_read" begin

            d = segy_read(Pkg.dir("SeisIO")*"/src/data/overthrust_2D_shot_1_20.segy",
                                                         buffer = true, warn_user = false)
            @test size(d) == (751, 3300)
            @test length(d) == 3300
            @test d.fileheader.bfh.DataSampleFormat == 1
            @test Float32.(d.data[1]) == 0
            @test d.traceheaders[1].SourceX == 400

            d = segy_read(Pkg.dir("SeisIO")*"/src/data/overthrust_2D_shot_1_20.segy",
                                                        buffer = false, warn_user = false)
            @test size(d) == (751, 3300)
            @test length(d) == 3300
            @test d.fileheader.bfh.DataSampleFormat == 1
            @test Float32.(d.data[1]) == 0
            @test d.traceheaders[1].SourceX == 400

            keys = ["SourceX"; "GroupX"]
            d = segy_read(Pkg.dir("SeisIO")*"/src/data/overthrust_2D_shot_1_20.segy",
                                                    keys, buffer = true, warn_user = false)
            @test size(d) == (751, 3300)
            @test length(d) == 3300
            @test d.fileheader.bfh.DataSampleFormat == 1
            @test Float32.(d.data[1]) == 0
            @test d.traceheaders[1].SourceX == 400

            d = segy_read(Pkg.dir("SeisIO")*"/src/data/overthrust_2D_shot_1_20.segy",
                                                    keys, buffer = false, warn_user = false)
            @test size(d) == (751, 3300)
            @test length(d) == 3300
            @test d.fileheader.bfh.DataSampleFormat == 1
            @test Float32.(d.data[1]) == 0
            @test d.traceheaders[1].SourceX == 400
        end
    end
end
