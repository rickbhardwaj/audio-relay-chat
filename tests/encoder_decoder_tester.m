% WORKING %
%%

bits_to_send = 1000-1;
amount_to_encode_as = 2*(1000-1);


x = randi([0,1],1,bits_to_send);
syms_per_encoding = ceil(amount_to_encode_as/Chat_parameters.m);
syms_required = ceil(bits_to_send/Chat_parameters.m);
for trial = 1:7
    start_time = tic;
    y = encode_bits(x,amount_to_encode_as, (trial-1)*syms_per_encoding + 1);
    fprintf('\n\nTrial %d encoded in %d seconds\n',trial,toc(start_time));
    y_erasures = [];
    syms_that_make_it = sort(randperm(syms_per_encoding,syms_required));
    for i = syms_that_make_it
        y_erasures = [y_erasures,y((i-1)*Chat_parameters.m + 1:i*Chat_parameters.m)];
    end
    start_time = tic;
    x_decoded = decode_bits(y_erasures,bits_to_send,syms_that_make_it + (trial-1)*syms_per_encoding);
    fprintf('Trial %d decoded in %d seconds\n',trial,toc(start_time));
    fprintf('The number of symbols that are different is %d\n\n',sum( xor(x_decoded,x) ));
end

disp('Finished tests!!');