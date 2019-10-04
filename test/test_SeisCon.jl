@testset "SeisCon" begin

    global s = segy_scan(joinpath(SegyIO.myRoot,"data/"), "overthrust", ["GroupX"; "GroupY"], verbosity = 0)
    @testset "Constructor" begin
        @test typeof(s) == SeisCon
        @test length(s) == 97
        @test size(s) == (97,)
        @test s.ns == 751
        @test s.dsf == 1
    end
    
    @testset "Indexing" begin
        @test typeof(s[1]) <: SeisBlock
        @test typeof(s[1:10]) <: SeisBlock
        @test typeof(s[1:10:20]) <: SeisBlock
        @test typeof(s[:]) <: SeisBlock
        @test typeof(s[[1; 4; 8; 12]]) <: SeisBlock
    end

    @testset "get_header" begin
        @test size(get_header(s, "GroupX")) == (97, 2)
        @test get_header(s, "GroupX")[1] == 2400
        @test get_header(s, "GroupX")[end] == 19900
    end

    @testset "get_sources" begin
        @test size(get_sources(s)) == (97, 2)
        @test get_sources(s)[1] == 8400
        @test get_sources(s)[end] == 0
    end

    @testset "merge" begin
        b = merge(s, s)
        @test b.ns == s.ns
        @test b.dsf == s.dsf
        @test length(b) == 194
    end

    @testset "split" begin
        b = split(s, 1:10);
        c = split(b, [1; 7; 9]);
        d = split(c, 1);
        @test s.blocks[1] === d.blocks[1]
    end
end
