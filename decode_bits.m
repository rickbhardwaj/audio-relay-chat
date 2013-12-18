function decoded_bits = decode_bits( bitstring, actual_length, offsets)
%decode_bits decodes bitstring, which is actual_length encoded bits
%   bitstring is the fountain encoding of actual_length bits. offsets are
%   the indicies of each of the symbols obtained in the fountain encoding.

if ( mod(length(bitstring),Chat_parameters.m) || length(offsets) ~= length(bitstring)/Chat_parameters.m || ceil(actual_length/Chat_parameters.m) ~=length(offsets) )
    disp('Decoder used incorrectly!!!');
    decoded_bits = zeros(1,actual_length);
    return;
end

k = length(bitstring)/Chat_parameters.m;
symbol_string = bi2de(reshape(bitstring,[],k)');

G = zeros(k,k);
j = 1;
for i = offsets
    rng(i + 179424673);
    G(j,1:k) = randi([0,2^Chat_parameters.m-1],1,k);
    j = j + 1;
end
G_gf = gf(G,Chat_parameters.m); 
y_gf = gf(symbol_string,Chat_parameters.m);
x_gf = G_gf\y_gf;

decoded_symbols = double(x_gf.x);
decoded_bits = reshape( de2bi( decoded_symbols, Chat_parameters.m )', [], 1)';
decoded_bits = decoded_bits(1:actual_length);
end