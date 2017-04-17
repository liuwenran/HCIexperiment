function [ frameNo ] = nameToNumber( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

stringlen = length(input_args);
for i = stringlen:-1:1
	if input_args(i) == '.'
		flagr = i - 1;
	end
	if input_args(i) == '_'
		flagl = i + 1;
		break;
	end
end

frameNo = str2num(input_args(flagl:flagr));

end

