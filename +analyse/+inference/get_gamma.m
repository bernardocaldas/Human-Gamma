function [ gamma ] = get_gamma(env, varrewards,trace,domests,probests)
%GET_X Get the estimate of x at the switching points;
%   Inputs: rewards_visit - Rewards at visit states:
%           domests - Domininant policy at each visit of the visit states

actions=trace.actions;
states=trace.states(1:end-1);
varrewards=env.varrewards(1:length(states));
visit=states==env.reward_state;
pswitch= analyse.inference.get_switiching_points(domests(1,states==1));
indices=find((actions(visit)==env.reward_action));
rewards_visit=varrewards(visit&(actions==env.reward_action));
x0=1;
fitnessfn=@(x)getgamma(x,pswitch,rewards_visit,indices,env,probests);
% [minsigma minstd]= fmincon(fitnessfn,10,[],[],[],[],0.1,floor(length(rewards_visit)/6))
options = optimoptions('fmincon');
options = optimoptions(options,'UseParallel','always');
options = optimoptions(options,'Algorithm', 'active-set');
problem = createOptimProblem('fmincon','x0',x0,'objective',fitnessfn,'lb',0.1,'ub',floor(length(rewards_visit)),'options',options);
gs = GlobalSearch('MaxTime',10,'Display','off');
ms = MultiStart('MaxTime',10,'Display','off');
[minsigma,minscore] = run(ms,problem,10);

[minstd gamma]=getgamma(minsigma,pswitch,rewards_visit,indices,env,probests);

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
% %     filter = exp(y/sigma);
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
function [score,avgamma]= getgamma(sigma,pswitch,rewards_visit,indices,env,probests)
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
    for i=1:length(x)
        if env.numstates==2
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)));
        elseif env.numstates==3
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)),probests(3,pswitch(i)));
        end
    end
    avgamma=mean(gamma);
    score=std(gamma)/(betapdf(avgamma,2,2)^2);
    catch
        fprintf('Error!');
        score=+Inf;
        avgamma=0;
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


