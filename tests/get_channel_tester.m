% WORKING %

%%
% initialize
clear('prober');
f_lowest = 200;
f_highest = 7000;
num_of_channels = 5;
Fs = 44000;
refresh_time = 60;
bandwidth = (f_highest - f_lowest)/num_of_channels;
t = 0:1/Fs:20;
occupying_waveform = t*0;
for i = 1:num_of_channels
    occupying_waveform = occupying_waveform + sin((f_lowest + (i-1)*bandwidth + .98*bandwidth)*2*pi*t);
end
occupying_waveform = occupying_waveform/num_of_channels;
prober = audiorecorder(Fs,24,1);
prober.StartFcn = 'disp(''Prober has been initialized'')';
prober.TimerFcn = 'disp(''Prober being refreshed''); stop(prober);record(prober);';
prober.TimerPeriod = refresh_time;
%prober.StopFcn = '';

record(prober);

%%
% test
no_occupying_repeats = 4;
fprintf('Going to test the channel prober. Please go wild and make lots of noises\n\n');
pause(3);

fprintf('Trying to get a channel %d times when none of them are occupied.\n',no_occupying_repeats);
fprintf('These should happen immediately\n\n');
start_time = tic;
for i = 1:no_occupying_repeats
    fprintf('For trial %d, acquired channel %d in %d seconds\n',i,get_channel(num_of_channels,f_lowest,f_highest,prober),toc(tic));
    start_time = tic;
end

fprintf('\nNow trying to acquire a channel when all of them are occupied\n');
sound(occupying_waveform, Fs);
pause(3);
fprintf('A channel should not be occupied until the sound is over\n\n');
fprintf('Trying to occupy a channel...\n');
i = get_channel(num_of_channels,f_lowest,f_highest,prober);
fprintf('Acquired channel #%d, whose occupying frequency is %d\n\n',i,(f_lowest + i*bandwidth + .98*bandwidth));
fprintf('Test over!\n\n\n');