classdef Chat_parameters
    %A list of consolidated chat parameters so that things can be changed
    %in one place
    
    properties (Constant)
        %% general constants %%
        lowest_f = 1000;
        highest_f = 7000;
        Fs = 44000;
        window_size = 1;
        recorder_init_time = 1;
        prober_refresh_time = 60;
        occupy_position = .98;
        
        
        %% get_channel constants %%
        min_probe_time = .05;
        max_probe_time = .15;
        
        %% sender and receiver parameters %%
        length_bits = 10;
        R_initial = .5;
        R_worst = .1;
        bits_per_burst = 15;
        burst_duration = .5;
        length_position = .02;
        message_start_position = .04;
        message_end_position = .96;
        
        ARQ_listen_duration = 1;
        
        chirp_repeats = 2;
        
        start_strengths_length = 10;
        
        %% encoder and decoder parameters %%
        m = 5;
        
        %% output bits of hashcode. %%
        hashbits = 5;
        
    end
    
end

