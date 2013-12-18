function send_message( message, start_freq, end_freq )
%send_message sends the message string along the channel starting from
%start_freq and ending at end_freq. 
%   First, message is encoded into bits. Then it is encoded into many bits
%   via a fountain code. These are sent over. Then the sender listens to
%   see if anyone needs more of the message to be transmitted because of
%   too many erasures. 

  
send_thread = timer('TimerFcn',{@sending_wrapper, message, start_freq, end_freq},...
    'TasksToExecute', 1,...
    'StartDelay',.001,...
    'ExecutionMode', 'fixedRate');
start(send_thread);
end


function actual_send_message(message, start_freq, end_freq)
bits_message = string_to_bits(message);
message_length = length(bits_message);

if(message_length >= 2^Chat_parameters.length_bits)
    disp('Message you were trying to send was too long!');
    return;
end

length_bitstring = de2bi(message_length, Chat_parameters.length_bits);

occupying_frequency = start_freq + (end_freq - start_freq)*Chat_parameters.occupy_position;

len_start_freq = start_freq;
len_end_freq = start_freq + (end_freq - start_freq)*Chat_parameters.length_position;

temp_cell = num2cell([start_freq + (end_freq - start_freq)*Chat_parameters.message_start_position, start_freq + (end_freq - start_freq)*Chat_parameters.message_end_position]);
[start_freq, end_freq] = temp_cell{:};


hashcode = get_hash(bits_message);
bits_message = [bits_message,hashcode];
num_of_bits_to_send = message_length + Chat_parameters.hashbits;
syms_required = ceil(num_of_bits_to_send/Chat_parameters.m);

R = Chat_parameters.R_initial;
total_transmitted_syms = 0;
total_transmitted_length_syms = 0;
retransmitting = 0;
ARQ_probe = audiorecorder(Chat_parameters.Fs, 24, 1);
record(ARQ_probe);
while (1)
    %fprintf('\nR = %d\n',R);
    syms_to_send = ceil(ceil(num_of_bits_to_send/R)/Chat_parameters.m);

    num_of_bursts = ceil(syms_to_send*Chat_parameters.m/Chat_parameters.bits_per_burst);
    
    encoded_bits_message = encode_bits(bits_message, ceil(num_of_bits_to_send/R), total_transmitted_syms + 1);
    encoded_length_bitstring = encode_bits(length_bitstring, num_of_bursts*Chat_parameters.m, total_transmitted_length_syms + 1);
    if retransmitting
        start_wave = repmat( sin_chirp(Chat_parameters.burst_duration, end_freq, start_freq, Chat_parameters.Fs), 1, Chat_parameters.chirp_repeats);
        end_wave = repmat( sin_chirp(Chat_parameters.burst_duration, end_freq, start_freq, Chat_parameters.Fs), 1, Chat_parameters.chirp_repeats);
    else
        start_wave = repmat( sin_chirp(Chat_parameters.burst_duration, start_freq, end_freq, Chat_parameters.Fs), 1, Chat_parameters.chirp_repeats);
        end_wave = repmat( sin_chirp(Chat_parameters.burst_duration, start_freq, end_freq, Chat_parameters.Fs), 1, Chat_parameters.chirp_repeats);
    end
    
    message_waveform = bits_to_wave(encoded_bits_message, start_freq, end_freq, Chat_parameters.bits_per_burst, Chat_parameters.burst_duration, Chat_parameters.Fs);
    length_waveform = bits_to_wave(encoded_length_bitstring, len_start_freq, len_end_freq, Chat_parameters.m, Chat_parameters.burst_duration, Chat_parameters.Fs);
    %sound(start_wave,44000);
    pause(1);
    message_waveform = [start_wave,message_waveform,end_wave];
    length_waveform = [zeros(1,length(start_wave)),length_waveform, zeros(1,length(end_wave))];
    
    if(length(length_waveform) ~= length(message_waveform))
        disp('Error in converting bits to wave!');
        return;
    end
    t = linspace(0,length(message_waveform)/Chat_parameters.Fs, length(message_waveform));
    occupying_waveform = sin(occupying_frequency*2*pi*t);
    
    output_waveform = message_waveform + length_waveform + occupying_waveform;
    output_waveform = output_waveform/max(abs(output_waveform));
    
    total_transmitted_syms = total_transmitted_syms + syms_to_send;
    total_transmitted_length_syms = total_transmitted_length_syms + num_of_bursts;
    
    sound(output_waveform,Chat_parameters.Fs);
    pause(length(output_waveform)/Chat_parameters.Fs);
    sound(occupying_waveform(1:ceil(Chat_parameters.ARQ_listen_duration*Chat_parameters.Fs)),Chat_parameters.Fs);
    decode_progress = ARQ(len_end_freq, start_freq, end_freq, Chat_parameters.ARQ_listen_duration,ARQ_probe);
    %fprintf('\nDecode progress: %d\n',decode_progress);
    stop(ARQ_probe);
    record(ARQ_probe);
    if( decode_progress == 1 );
        break;
    end
    p_success = floor(decode_progress*syms_required)/total_transmitted_syms;
    R = p_success/(1-decode_progress);
    R = max(R/2,Chat_parameters.R_worst); 
    retransmitting = 1;
end

end

function sending_wrapper(thread, thing, message, start_freq, end_freq)
    actual_send_message(message,start_freq,end_freq);
end