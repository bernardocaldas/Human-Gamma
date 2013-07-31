function [ x ] = get_x( varrewards,trace,domests)
%GET_X Get the estimate of x at the switching points;
%   Inputs: rewards_visit - Rewards at visit states:
%           domests - Domininant policy at each visit of the visit states

actions=trace.actions;
states=trace.states(1:end-1);
visit=states==1;
pswitch= analyse.inference.get_switiching_points(domests(1,visit));
lastaction=[0 actions(1:end-1)];
indices=find((lastaction(visit)==1));
rewards_visit=varrewards(visit&(lastaction==1));
x0=1;
fitnessfn=@(x)getstd(x,pswitch,rewards_visit,indices);
[minsigma minstd]= fmincon(fitnessfn,x0,[],[],[],[],0.1,floor(length(rewards_visit)/10))

[minstd x]=getstd(minstd,pswitch,rewards_visit,indices);

% a=1;
% for sigma = linspace(1,50,50);
%    windowsize =ceil(6*sigma);
%     y = linspace(-windowsize, 0, windowsize);
%     filter = exp(-y .^ 2 / (2 * sigma ^ 2));
%     filter = filter / sum (filter); % normalize
%     
%     filtered_rewards = rewards_visit;
%     lfilter=length(filter);
%     for j=lfilter:length(rewards_visit)
%         filtered_rewards(j) = filter*rewards_visit(j-lfilter+1:j);
%     end
%     x=estimates_at_switch(pswitch,filtered_rewards,indices);
%     means(a)=mean(x)
%     stds(a)=std(x)
%     a=a+1;
% end
% % a=1;
% % for sigma = linspace(0.1,1.5,50);
% %     windowsize =ceil(3/sigma);
% %     y = linspace(-windowsize, 0, windowsize);
% %     filter = exp(sigma*y);
% %     filter = filter / sum (filter); % normalize
% %     
% %     filtered_rewards = rewards_visit;
% %     lfilter=length(filter);
% %     for j=lfilter:length(rewards_visit)
% %         filtered_rewards(j) = filter*rewards_visit(j-lfilter+1:j);
% %     end
% %     x=filtered_rewards(pswitch);
% %     means(a,2)=mean(x)
% %     stds(a,2)=std(x)
% %     a=a+1;
% % end
% [minstd minindex]=min(stds);
% x=means(minindex);

end
function [stdev, average]= getstd(sigma,pswitch,rewards_visit,indices)
try
    windowsize =ceil(6*sigma);
    y = linspace(-windowsize, 0, windowsize);
    filter = exp(-y .^ 2 / (2 * sigma ^ 2));
    filter = filter / sum (filter); % normalize
    
    filtered_rewards = rewards_visit;
    lfilter=length(filter);
    for j=lfilter:length(rewards_visit)
        filtered_rewards(j) = filter*rewards_visit(j-lfilter+1:j);
    end
    x=estimates_at_switch(pswitch,filtered_rewards,indices);
    average=mean(x);
    stdev=std(x);
catch
    stdev=+Inf;
    average=0;
end
end
function estimates = estimates_at_switch(pswitch,filtered_rewards,indices)
estimates=0;
for i=1:length(pswitch)
   for j=1:length(indices)-1
       if (indices(j+1)<=pswitch(i)&&j~=length(indices)-1)
           continue
       else
           estimates(i)=filtered_rewards(j);
           break;
       end
   end
           
end
end


