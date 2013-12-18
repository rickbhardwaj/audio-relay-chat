function repeat_request(decode_progress, occupying_freq, f_low, f_high, send_duration, Fs);
%ARQ listens for listen_duration and outputs the minimum decode progress it
%hears from the receivers
%   If occupying_freq is not acquired, then all recievers decoded correctly
%   presumably (decode_progress = 1). If occupying_freq is acquired, then
%   looks for the lowest pure tone between f_low and f_high, and
%   uses that to find the decode progress.
    
    % WORKING
    
    t = 0:1/Fs:send_duration;
    occupy_tone = sin(2*pi*occupying_freq*t);
    request_freq = (f_high - f_low)*decode_progress + f_low;
    request_tone = sin(2*pi*request_freq*t);
    output_wave = occupy_tone + request_tone;
    output_wave = output_wave/max(abs(output_wave));
    sound(output_wave, Fs);
end