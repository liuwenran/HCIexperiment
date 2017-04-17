function [ output_args ] = locateKeyPoints( test_points )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
% up a down b,left i right bj

a1 = test_points(32,:) - 0.5 * (test_points(38,:) - test_points(32,:));
a2 = test_points(41,:) + test_points(41,:) - test_points(48,:);
a3 = test_points(38,:) + 0.5 * (test_points(38,:) - test_points(32,:));

output_args = [test_points(1,:);test_points(3,:);test_points(8,:);
                test_points(10,:);a3;a2;a1];
end

