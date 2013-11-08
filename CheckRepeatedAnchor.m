function [ RepeatedAnchor ] = CheckRepeatedAnchor( AnchorNum )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global AnchorNodes;

[m,n]=size(AnchorNodes);
RepeatedAnchor = 0;
for i=1:m
    if(AnchorNodes{i,1}(1,3)==AnchorNum)
        RepeatedAnchor = 1;
        break;
    end
end

