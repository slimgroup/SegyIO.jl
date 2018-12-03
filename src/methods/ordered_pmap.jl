export ordered_pmap

function ordered_pmap(pool::WorkerPool, f, list)

    pids = pool.workers
    np = length(pids)
    n = length(list)
    results = Vector{Any}(undef,n)
    i = 1
    nextidx() = (idx=i; i+=1; idx)
    @sync begin
        for p in pids
            if p != myid() || np == 1
                @async begin
                    while true
                        idx = nextidx()
                        if idx > n
                            break
                        end
                        results[idx] = remotecall_fetch(f, p, list[idx])
                    end
                end
            end
        end
    end
    return results
end

ordered_pmap(f, c1,) = ordered_pmap(default_worker_pool(), f, c1)
ordered_pmap(f, c1, c...) = ordered_pmap(default_worker_pool(), a->f(a...), zip(c1,c))
ordered_pmap(p::WorkerPool, f, c1, c...) = ordered_pmap(p, a->f(a...),zip(c1,c))
                                                                        
