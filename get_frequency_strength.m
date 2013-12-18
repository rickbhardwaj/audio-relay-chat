function strength = get_frequency_strength( f, waveform, Fs, window_size )
%get_frequency_strength gives the magnitude of the strength of f in the fft
%of waveform, which was sampled at a rate Fs.
%   Takes the fft of waveform, finds the frequency f using Fs, and returns
%   the magnitude of the fft in a window of window_size around f.

y_freq = abs(fft(waveform));
f_index = round(f/Fs*length(waveform)) + 1;

f_lower_index = f_index - floor(window_size/2);
f_upper_index = f_lower_index + window_size - 1;

strength = sum( y_freq(f_lower_index:f_upper_index) )/window_size;

end

