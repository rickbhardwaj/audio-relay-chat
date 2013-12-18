function decode_progress = ARQ(occupying_freq, f_low, f_high, listen_duration, ARQ_probe);
%ARQ listens for listen_duration and outputs the minimum decode progress it
%hears from the receivers
%   If occupying_freq is not acquired, then all recievers decoded correctly
%   presumably (decode_progress = 1). If occupying_freq is acquired, then
%   looks for the lowest pure tone between f_low and f_high, and
%   uses that to find the decode progress.
    
    % WORKING
    
    pause(listen_duration);
    probe_data = getaudiodata(ARQ_probe);
    probe_data = probe_data(end-listen_duration*ARQ_probe.SampleRate:end);

    % check to see if channel_num is occupied
    f_i_low = round(f_low/ARQ_probe.SampleRate*length(probe_data)) + 1;
    f_i_high = round(f_high/ARQ_probe.SampleRate*length(probe_data)) + 1;
    channel_freqs = abs(fft(probe_data));
    %plot(linspace(0,44000,length(probe_data)),channel_freqs);
    %figure;
    channel_freqs = channel_freqs(f_i_low:f_i_high);
    channel_freqs = channel_freqs;
    occupy_freq_strength = get_frequency_strength(occupying_freq,probe_data,ARQ_probe.SampleRate,Chat_parameters.window_size);
    %disp(occupy_freq_strength);
    %disp(length(channel_freqs));
    %plot(linspace(f_low,f_high,length(channel_freqs)), channel_freqs);
    if(sum(channel_freqs>(occupy_freq_strength/2)) > length(channel_freqs)*.6)
        % ARQ channel didn't get occupied, so everyone decoded fully.
        decode_progress = 1;
    else
        decode_progress = find(channel_freqs>(occupy_freq_strength/4));
        %disp(decode_progress);
        decode_progress = decode_progress(1)/length(channel_freqs);
    end
end

