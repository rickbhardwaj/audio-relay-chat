function encoded_bits = encode_bits( bitstring, encoding_size, offset)
%encode_bits encodes bitstring as encoding_size number of bits
%   this is a fountain encoder, so offset should be the index of the first
%   symbol this function will produce. For the first encoding, offset should
%   be 1.

N = ceil(encoding_size/Chat_parameters.m);
k = ceil(length(bitstring)/Chat_parameters.m);
bitstring = [ bitstring, zeros(1,k*Chat_parameters.m-length(bitstring)) ];
symbol_string = bi2de(reshape(bitstring,[],k)');

G = zeros(N,k);
for i = 1:N
    rng(i+offset-1 + 179424673);
    G(i,1:k) = randi([0,2^Chat_parameters.m-1],1,k);
end
G_gf = gf(G,Chat_parameters.m); 
x_gf = gf(symbol_string,Chat_parameters.m);
y_gf = G_gf*x_gf;
encoded_symbols = double(y_gf.x);
encoded_bits = reshape( de2bi( encoded_symbols, Chat_parameters.m )', [], 1)';

end

