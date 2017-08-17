export find_next_delim

function find_next_delim(x::AbstractVector, i::Int, probe_length::Int)
    
    # Setup
    j_prev = i
    j = j_prev + probe_length
    undershoot_counter = 0
    end_counter = 0
    n = length(x)
    probed_end_flag = false

    # Evaluate probe and update
    while true
        
        # Check inbounds, and update values
        if j <= n
            val = x[j_prev]
            probed_val = x[j]

            # Undershoot delim
            if val == probed_val
                j_prev = j
                j += probe_length
                undershoot_counter += 1

                # If keep undershooting, extend probe unless at end of x
                if (undershoot_counter >= 10) & ~probed_end_flag
                    probe_length *= 10
                    undershoot_counter = 0
                end

            # Delim found    
            elseif j_prev + 1 == j
                return j
            
            # Overshoot delim
            else
                j = j_prev
                probe_length = floor(Int, probe_length/2)
            end 

        # Probed out of bounds
        else
            j = n
            probe_length = 1
            probed_end_flag = true
            (end_counter>10) ? (return j) : (end_counter += 1)
        end
    end
end
