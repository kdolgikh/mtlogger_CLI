function [conv_result] = transform_conv_result(byte1,byte2,byte3)
% Transforms conversion result of 24 bytes into one double
% Double format is chosen because it can hold NaN

conv_result = double(byte1)*2^16 + double(byte2)*2^8 + double(byte3);

end

