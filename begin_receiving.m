function begin_receiving( start_freq, end_freq )
%begin_receiving starts up the receiver for the channel from start_freq to
%end_freq.
%   The receiver for the channel listens constantly, and every time it
%   hears a message on this particular channel, it starts a new audio
%   receiver and spends its time decoding the message it just got, and the
%   passing it on to the front end through submit_received_message

%system('matlab -nodisplay -nosplash -nodesktop -nojvm -minimize -r "send_message(''hey nigga, how you doin?'', 4000, 5000); pause(20);exit;" &')



disp('begin receiver is not implemented yet!');

occupying_frequency = start_freq + (end_freq - start_freq)*Chat_parameters.occupy_position;

len_start_freq = start_freq;
len_end_freq = start_freq + (end_freq - start_freq)*Chat_parameters.length_position;

temp_cell = num2cell([start_freq + (end_freq - start_freq)*Chat_parameters.message_start_position, start_freq + (end_freq - start_freq)*Chat_parameters.message_end_position]);
[start_freq, end_freq] = temp_cell{:};

prober = audiorecorder(Chat_parameters.Fs, 24, 1);
start_time = tic;
record(prober);
pause(Chat_parameters.recorder_init_time);

remainder_message_bits = [];

required_length_syms = ceil(Chat_parameters.length_bits/Chat_parameters.m);
required_message_syms = -1;

received_length_bits = [];
curr_message_sym = 1;
curr_length_sym = 1;
received_message_bits = [];
received_messsage_sym_i = [];
received_length_bits = [];
received_length_sym_i = [];
message_size = -1;

retransmission = 0;
curr_i = 1;
while (1)
    
    received_start = 0;
    start_strengths = randi(1,Chat_parameters.start_strengths_length)/100000;
    if(retransmission)
        start_signal = sin_chirp(Chat_parameters.burst_duration, end_freq, start_freq, Chat_parameters.Fs);
    else
        start_signal = sin_chirp(Chat_parameters.burst_duration, start_freq, end_freq, Chat_parameters.Fs);
    end
    
    while(~received_start)
        
        if(~retransmission && toc(start_time)>Chat_parameters.prober_refresh_time)
            stop(prober);
            record(prober);
            start_time = tic;
            curr_i = 1;
            pause(Chat_parameters.recorder_init_time);
        end
        pause(2*Chat_parameters.burst_duration);
        
        probe_data = getaudiodata(prober);
        probe_data = probe_data(curr_i:end);
        
        [curr_start_strength,loc] = max(abs(xcorr(start_signal,probe_data)));
        loc = curr_i + length(probe_data) - loc;
        if(sum(start_strengths>curr_start_strength) == 0)
            i = loc;
            j = 1;
            while(j ~= -1 && j < Chat_parameters.chirp_repeats)
                while(length(getaudiodata(prober))-i+1 < length(start_signal)); end;
                probe_data = getaudiodata(prober);
                probe_data = probe_data(i:i+length(start_signal));
                repeat_strength = max(abs(xcorr(start_signal,probe_data)));
                if(sum(start_strengths>repeat_strength) == 0)
                    j = j + 1;
                    i = loc + length(start_signal);
                else
                    j = -1;
                end
            end
            if(j == Chat_parameters.chirp_repeats)
                curr_i = loc + Chat_parameters.chirp_repeats*length(start_signal);
                received_start = 1;
            end
        end
        
        if(~ received_start)
            curr_i = curr_i + Chat_parameters.Fs*2*Chat_parameters.burst_duration;
            start_strengths(2:end) = start_strengths(1:end-1);
            start_strengths(1) = curr_start_strength;
        end
    end
    
    received_end = 0;
    end_strengths = randi(1,Chat_parameters.start_strengths_length)/100000;
    if(retransmission)
        end_signal = sin_chirp(Chat_parameters.burst_duration, end_freq, start_freq, Chat_parameters.Fs);
    else
        end_signal = sin_chirp(Chat_parameters.burst_duration, start_freq, end_freq, Chat_parameters.Fs);
    end
    
    while(~received_end)
        
        while(length(getaudiodata(prober))-curr_i+1 < Chat_parameters.Fs*Chat_parameters.burst_duration + 1); end;
        
        probe_data = getaudiodata(prober);
        probe_data = probe_data(curr_i:curr_i + Chat_parameters.Fs*Chat_parameters.burst_duration + 1);
        wave_data = probe_data;
        [curr_end_strength,loc] = max(abs(xcorr(end_signal,probe_data)));
        loc = curr_i + length(probe_data) - loc;
        if(sum(end_strengths>curr_end_strength) == 0)
            i = loc;
            j = 1;
            while(j ~= -1 && j < Chat_parameters.chirp_repeats)
                while(length(getaudiodata(prober))-i+1 < length(end_signal)); end;
                probe_data = getaudiodata(prober);
                probe_data = probe_data(i:i+length(end_signal));
                repeat_strength = max(abs(xcorr(end_signal,probe_data)));
                if(sum(end_strengths>repeat_strength) == 0)
                    j = j + 1;
                    i = loc + length(end_signal);
                else
                    j = -1;
                end
            end
            if(j == Chat_parameters.chirp_repeats)
                curr_i = loc + Chat_parameters.chirp_repeats*length(end_signal);
                received_end = 1;
            end
        end
        
        
        
        if(~ received_end)
            
            message_bits = wave_to_bits(wave_data, start_freq, end_freq, Chat_parameters.bits_per_burst, occupying_frequency, Chat_parameters.Fs);
            if( length(received_length_syms) < required_length_syms )
                length_bits = wave_to_bits(wave_data, len_start_freq, len_end_freq, Chat_parameters.m, occupying_frequency, Chat_parameters.Fs);
                length_errors = sum( length_bits == -1 );
                if( length_errors == 0 )
                    received_length_bits = [received_length_bits, length_bits];
                    received_length_syms_i = [received_length_syms_i, curr_length_sym];
                end
                if(length(received_length_bits) == required_length_syms)
                    message_size = bi2de(decode_bits(received_length_bits,Chat_parameters.length_bits,received_length_syms_i));
                    required_message_syms = ceil(message_size/Chat_parameters.m);
                end
            end
            
            curr_length_sym = curr_length_sym + 1;
            
            message_bits = [remainder_message_bits, message_bits];
            i = 1;
            while(length(message_bits) - i + 1 >= Chat_parameters.m)
                sym_errors = sum( message_bits(i:i+Chat_parameters.m-1) == -1 );
                if( sym_errors == 0)
                    received_message_bits = [received_message_bits, message_bits(i:i+Chat_parameters.m-1)];
                    received_message_syms_i = [received_message_syms_i, curr_message_sym];
                end
                curr_message_sym = curr_message_sym + 1;
                i = i + Chat_parameters.m;
                if(message_size ~= -1 && length(curr_message_sym_i) == required_message_syms)
                    received_end = 1;
                    break;
                end
            end
            
            remainder_message_bits = message_bits(i:end);
            
            curr_i = curr_i + Chat_parameters.Fs*Chat_parameters.burst_duration + 1;
            end_strengths(2:end) = end_strengths(1:end-1);
            end_strengths(1) = curr_end_strength;
        end
        
    end
    
    
end
% [val, i] = max(abs(xcorr(special,test_wave)));test_wave(length(test_wave)-i+1)
end

