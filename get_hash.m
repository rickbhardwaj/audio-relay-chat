function hashcode = get_hash( input_message )
%get_hash takes a bitstring and returns an 7-bit hashcode in the form of an
%7-element array

% get_hashed get a random length input message then output a 7-bits
% hashcode. The input bit array is converted to a decimal number and then
% the decimal number is used as the seed of the rand(). The rand() will
% produce some number of bits then use that as hashcode.

deci = mod(bi2de(input_message), 2^32);
rng(deci);
thePrime = primes(2 ^ Chat_parameters.hashbits);
toHash = mod(floor(rand() * (10 ^ Chat_parameters.hashbits)), thePrime(end));
hashcode = de2bi(toHash);
info = size(hashcode);
hashcode = [hashcode zeros(1 ,Chat_parameters.hashbits - info(2))];

end
