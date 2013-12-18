function submit_received_message( received_message )
%submit_received_message Passes on received_message to the chat front end
%by writing it to filename.
%   Appends received_message to filename, which gets read by the front end
%   to update the chat.

filename = 'recieveBuffer.txt';
strx = sprintf(received_message);
doc = fopen(filename, 'a');
fprintf(doc, '%s\n', strx);
fclose(doc);

doc = fopen('commandBuffer.txt', 'a');
fprintf(doc, '%s\n', strx);
fclose(doc);

% 
% %%%% delete the following line once the function has been implemented
% disp('submit_received_message not yet implemented!');

end

