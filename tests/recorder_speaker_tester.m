%% This script is to test your recorder, to see if it can be turned on to listen for short times 
t = 0:1/44000:5;
y = sin(440*2*pi*t);
recorder = audiorecorder(44000,24,1);
sound(y,44000);
pause(2)
recordblocking(recorder,.05);
plot(getaudiodata(recorder));
disp('We''ve just plotted what the recorder heard after listening for a short time. You should see some waveform (which is a 440 Hz tone)');