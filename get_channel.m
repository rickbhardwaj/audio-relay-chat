function channel_num = get_channel( num_of_channels, lowest_f, highest_f, prober )
%get_channel finds a random channel that is free and returns it's number.
%   First, a random channel number is picked. That channel is then probed
%   for some time to see if it's free. If it is, that channel number is
%   returned, else a new channel is chosen randomly and probed.

% WORKING %

channel_bandwidth = (highest_f-lowest_f)/num_of_channels;
while (1)
    channel_num = randi(num_of_channels)-1;
    % low frequency for this channel
    f_low = channel_bandwidth*channel_num+lowest_f;
    % high frequency for this channel
    f_high = f_low + channel_bandwidth;
    occupying_frequency = f_low + (f_high - f_low)*.98;
    f_high = f_low + (f_high - f_low)*.96;
    probe_time = Chat_parameters.min_probe_time + rand()*(Chat_parameters.max_probe_time - Chat_parameters.min_probe_time);
    
    % listen for probe_time
    start_time = tic;
    while (toc(start_time) < probe_time); end;
    probe_data = getaudiodata(prober);
    if(length(probe_data) < probe_time*Chat_parameters.Fs)
        continue;
    end
    probe_data = probe_data((end-floor(probe_time*Chat_parameters.Fs)):end);
    
    % check to see if channel_num is occupied
    f_i_low = round(f_low/Chat_parameters.Fs*length(probe_data)) + 1;
    f_i_high = round(f_high/Chat_parameters.Fs*length(probe_data)) + 1;
    channel_freqs = abs(fft(probe_data));
    channel_freqs = channel_freqs(f_i_low:f_i_high);
    occupy_freq_strength = get_frequency_strength(occupying_frequency,probe_data,Chat_parameters.Fs,Chat_parameters.window_size);

    if(sum(channel_freqs>(occupy_freq_strength/2)) > length(channel_freqs)*.9)
        % this channel isn't occupied
        %disp([f_low,f_high,occupying_frequency]);
        %disp(occupy_freq_strength);
        %plot(linspace(0,Chat_parameters.Fs,length(probe_data)),abs(fft(probe_data)));
        return;
    end 
end

end
