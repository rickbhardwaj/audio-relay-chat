% WORKING %

% Shows how your mic responds to different frequencies %

%%
% test
Fs = 44000;
recorder = audiorecorder(Fs,24,1);
sound(chirp(0:1/Fs:20,0,20,20000),Fs); 
pause(.5);
recordblocking(recorder,20);
y = getaudiodata(recorder);
y_f = abs(fft(y));
plot( linspace(0,20000,floor(length(y)*20000/Fs)), y_f(1:floor(length(y)*20000/Fs)) );