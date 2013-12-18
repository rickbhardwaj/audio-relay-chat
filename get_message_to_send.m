function message_to_send = get_message_to_send()
% get_message_to_send returns the message the user wants to send, else 
% returns no_message if the user hasn't asked to send anything.
%   Polls filename to check if a line was added. If a line was added, then
%   return that added line (which is what the user wants to send). If no
%   new line has been added, then the user doesn't want to send anything
%   yet, so return no_message.

no_message = 0;

filename = 'sendBuffer.txt';

message = textread(filename, '%s', 'delimiter', '\n');
doc2 = fopen(filename, 'w');
fclose(doc2);

info = size(message);
iter = info(1);
cascadeM = '';
if iter >= 1
    cascadeM = message(1);
    if iter >= 2
        for i = 1:(iter-1)
            cascadeM = strcat(cascadeM,'\n',message(i+1));
        end
    end
end


message_to_send = char(cascadeM);

%if strcmpi(message, '')
%    message_to_send = message;
%else
%    message_to_send = 0
%end

end