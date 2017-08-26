# Test SeisBlock type and methods

@testset "SeisBlock" begin

    @testset "Constructor" begin
        b = SeisBlock(rand(Float32,10,10))
        @test b.fileheader.bfh.ns == 10
        @test b.fileheader.bfh.DataSampleFormat == 5
    end

    @testset "Methods" begin
        b = SeisBlock(rand(Float32,10,10))
        @test size(b) == (10,10)
    end

    @testset "set_traceheader" begin
        b = SeisBlock(rand(Float32,10,10))
        set_traceheader!(b.traceheaders, :SourceX, 102*ones(Int32, 10)) 
        @test b.traceheaders[3].SourceX == 102
    end

    @testset "set_fileheader" begin
        b = SeisBlock(rand(Float32,10,10))
        set_fileheader!(b.fileheader.bfh, :ns, 12) 
        @test b.fileheader.bfh.ns == 12
    end

    @testset "set_header" begin
        b = SeisBlock(rand(Float32,10,10))
        set_header!(b, :ns, 12) 
        @test b.fileheader.bfh.ns == 12
        @test b.traceheaders[1].ns == 12

        set_header!(b, "ns", 13) 
        @test b.fileheader.bfh.ns == 13
        @test b.traceheaders[1].ns == 13

        set_header!(b, :SourceX, 12) 
        @test b.traceheaders[1].SourceX == 12

        set_header!(b, "SourceY", 13) 
        @test b.traceheaders[1].SourceY == 13

        set_header!(b, :GroupY, 14*ones(Int32, 10)) 
        @test b.traceheaders[1].GroupY == 14

        set_header!(b, "GroupX", 15*ones(Int32, 10)) 
        @test b.traceheaders[1].GroupX == 15
    end
end
       
