function bits = wave_to_bits(wave, f_low, f_high, bits_per_burst, occupying_freq, Fs)
%wave_to_bits converts a single burst waveform from bits_to_wave back into bits.
%   the frequency band of the waveform is from f_low to f_high. Erasured
%   bits are decoded as -1.

bits = zeros(1,bits_per_burst);

tones = linspace(f_low,f_high,bits_per_burst*2);
%plot(linspace(0,Fs,length(wave)),abs(fft(wave)));
occupying_freq_strength = get_frequency_strength(occupying_freq,wave,Fs,Chat_parameters.window_size);
%disp(occupying_freq_strength);
for j = 1:bits_per_burst
    off_strength = get_frequency_strength(tones(2*j-1),wave,Fs,Chat_parameters.window_size);
    on_strength = get_frequency_strength(tones(2*j),wave,Fs,Chat_parameters.window_size);
    %disp([off_strength,on_strength]);
    %disp([(j-1)*2+1,j*2])
    if(abs(off_strength-on_strength)<occupying_freq_strength/2)
        bits(j) = -1;
    elseif(on_strength > off_strength)
        bits(j) = 1;
    else
        bits(j) = 0;
    end
end

end

