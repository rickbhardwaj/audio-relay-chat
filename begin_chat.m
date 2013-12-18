function begin_chat( num_of_people , num_of_active_people)
%begin_chat starts the matlab backend for a chat with num_of_people
%   num_of_active_people

fprintf('Initializing chat...\n');


fprintf('\n\n');

num_of_channels = ceil(2.5*num_of_active_people);
lowest_f = Chat_parameters.lowest_f;
highest_f = Chat_parameters.highest_f;
channel_bandwidth = (highest_f-lowest_f)/num_of_channels;

for i = 0:num_of_channels
    fprintf('Initializing channel #%d...\n',i);
    start_freq = channel_bandwidth*i+lowest_f;
    end_freq = start_freq + channel_bandwidth;
    system(sprintf('matlab -nodisplay -nosplash -nodesktop -nojvm -minimize -r "begin_receiving(%d,%d);exit;" &',...
        start_freq,end_freq));
end

fprintf('\n\n');

fprintf('Initializing prober...\n');

prober = audiorecorder(Chat_parameters.Fs,24,1);
record(prober);
start_time = tic;
pause(Chat_parameters.recorder_init_time);

fprintf('\nDone initializing! Chat is ready to send messages!!\n');
sound(sin(440*2*pi*(0:1/Chat_parameters.Fs:.25)),Chat_parameters.Fs);

while (1)
    message_to_send = get_message_to_send();
    if( ischar(message_to_send) )
        channel_num = get_channel(num_of_channels, lowest_f, highest_f, prober);
        start_freq = channel_bandwidth*channel_num+lowest_f;
        end_freq = start_freq + channel_bandwidth;
        send_message(message_to_send,start_freq,end_freq);
    elseif(toc(start_time)>Chat_parameters.prober_refresh_time)
        stop(prober);
        record(prober);
        start_time = tic;
        pause(Chat_parameters.recorder_init_time);
    end
end

end

