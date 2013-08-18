function [ switching_points is_up ] = get_switiching_points( dominants )
%GET_SWITICHING_POINTS Summary of this function goes here
%   Detailed explanation goes here
switching_points=[];
is_up=[];
for i=2:length(dominants)
    if(dominants(i)~=dominants(i-1))
        switching_points=[switching_points i];
        if(dominants(i)>dominants(i-1))
            is_up=[is_up 1];
        else
            is_up=[is_up 0];
        end
    end
end


end

