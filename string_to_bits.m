function bit_message = string_to_bits( string_message )
%string_to_bits takes a string and converts it to an array of bits.

bit_message = reshape(dec2bin(double(string_message),7).',[],1);
bit_message = bit_message(:)'-'0';

end

