function [ switching_points ] = get_switiching_points( dominants )
%GET_SWITICHING_POINTS Summary of this function goes here
%   Detailed explanation goes here
switching_points=[];
for i=2:length(dominants)
    if(dominants(i)~=dominants(i-1))
        switching_points=[switching_points i];
end


end

