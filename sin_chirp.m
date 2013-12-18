function waveform = sin_chirp( duration,f0,f1,Fs )
%sin_chirp returns a chirp swept from f0 to f1 over duration seconds.

t = 0:1/Fs:duration;
waveform = sin(2*pi*((f1-f0)/duration*t+f0).*t);

end

