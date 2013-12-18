function waveform = bits_to_wave(bits, f_low, f_high, bits_per_burst, burst_duration, Fs)
%bits_to_wave converts input bits to a waveform
%   The frequency band of the
%   sent waveform is f_low to f_high. The bits are put into several
%   bursts of length burst_duration.



t = 0:1/Fs:burst_duration;


num_of_bursts = ceil(length(bits)/bits_per_burst);
message_wave = zeros(1,length(t)*num_of_bursts);

tones = linspace(f_low,f_high,bits_per_burst*2);
j = 1;
for i = 1:num_of_bursts
    signal = 0*t;
    for bit = bits(j:min(j-1+bits_per_burst,end))
        if bit == 0
            signal = signal + sin(2*pi*tones(mod((j-1)*2, 2*bits_per_burst)+1)*t);
        else
            signal = signal + sin(2*pi*tones(mod((j-1)*2+1, 2*bits_per_burst)+1)*t);
        end
        j = j + 1;
    end
    message_wave((i-1)*length(t)+1:i*length(t)) = signal;
end
message_wave = message_wave/max(abs(message_wave));


waveform = message_wave;
end

