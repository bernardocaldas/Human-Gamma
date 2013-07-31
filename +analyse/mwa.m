function [ result, errs ] = mwa(values,window)
% MWA - moving window average
    for i=1:(length(values)-window+1)
        result(i) = mean(values(i:i+window-1));
        if nargout > 1
            errs(i) = var(values(i:i+window-1))/sqrt(window);
        end
    end    
end
