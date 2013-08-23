function [filtered_rewards]= filter_rewards(method,sigma,rewards_visit)
if strcmp(method,'gauss')==1
    windowsize =ceil(3*sigma);
    y = linspace(-windowsize+1, 0, windowsize);
    filter = exp(-y .^ 2 / (2 * sigma ^ 2));
    filter = filter / sum (filter); % normalize
end
if strcmp(method,'exp')==1
    windowsize =ceil(3*sigma);
    y = linspace(-windowsize+1, 0, windowsize);
    filter = exp(y/sigma);
    filter = filter / sum (filter);
end
rewards_visit=rewards_visit(:);
filtered_rewards = rewards_visit';
lfilter=length(filter);
for j=1:lfilter
    mini_filter=filter(end-j+1:end)/sum(filter(end-j+1:end));
    filtered_rewards(j)=mini_filter*rewards_visit(1:j);
end
for j=lfilter:length(rewards_visit)
    filtered_rewards(j) = filter*rewards_visit(j-lfilter+1:j);
end
end