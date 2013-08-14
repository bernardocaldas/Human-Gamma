function [ gamma ] = topdown_gamma(env,game, varrewards,trace,domests,probests)
%GET_X Get the estimate of x at the switching points;
%   Inputs: rewards_visit - Rewards at visit states:
%           domests - Domininant policy at each visit of the visit states

actions=trace.actions;
states=trace.states(1:end-1);
rewards=trace.rewards;
varrewards=env.varrewards(1:length(states));
visit=states==env.reward_state;
pswitch= analyse.inference.get_switiching_points(domests(1,states==1));
indices=find((actions(visit)==env.reward_action));
rewards_visit=rewards(visit&(actions==env.reward_action));rewards_visit=rewards_visit/max(rewards_visit); %
% rewards_visit=varrewards(visit&(actions==env.reward_action));
x0=1;


fitnessfn=@(x)get_gamma_gauss(x,pswitch,rewards_visit,indices,env,game,probests);
% [minsigma minstd]= fmincon(fitnessfn,10,[],[],[],[],0.1,floor(length(rewards_visit)/6))
options = optimoptions('fmincon');
options = optimoptions(options,'UseParallel','always');
options = optimoptions(options,'Algorithm', 'active-set');
problem = createOptimProblem('fmincon','x0',x0,'objective',fitnessfn,'lb',1,'ub',floor(length(rewards_visit)/10),'options',options);
gs = GlobalSearch('MaxTime',20,'Display','off');
ms = MultiStart('MaxTime',20,'Display','off');
[minsigma,minscore] = run(ms,problem,30);
[minstds(1) gammas(1)]=get_gamma_gauss(minsigma,pswitch,rewards_visit,indices,env,game,probests);

[minstd minindex]=min(minstds);
gamma=gammas(minindex);

% % a=1;
% % for sigma = linspace(0.1,1.5,50);
% %     windowsize =ceil(3/sigma);
% %     y = linspace(-windowsize, 0, windowsize);
% %     filter = exp(y/sigma);
% %     filter = filter / sum (filter); % normalize
% %     
end
function [score,avgamma]= get_gamma_gauss(sigma,pswitch,rewards_visit,indices,env,game,probests)
try
    windowsize =ceil(3*sigma);
    y = linspace(-windowsize, 0, windowsize);
    filter = exp(-y .^ 2 / (2 * sigma ^ 2));
    filter = filter / sum (filter); % normalize
    
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
    x=estimates_at_switch(pswitch,filtered_rewards,indices);
    for i=1:length(x)
        if game==1||game==2
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)));
        elseif game==3||game==4
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)),probests(3,pswitch(i)));
        elseif game==5
            gamma(i)=env.get_gamma(x(i),1);
        elseif game==6
            gamma(i)=env.get_gamma(x(i),0,0);
        end
    end
    avgamma=mean(gamma);
    score=std(gamma)/(betapdf(avgamma,2,2)^2);
    catch err
        fprintf('Error!');
        score=+Inf;
        avgamma=0;
    end
end

function [score,avgamma]= get_gamma_av(n,pswitch,rewards_visit,indices,env,game,probests)
    try
        n=round(n);
        filtered_rewards=rewards_visit;
    for j=n:length(rewards_visit)
        filtered_rewards(j) = sum(rewards_visit(j-n+1:j));
    end
    x=estimates_at_switch(pswitch,filtered_rewards,indices);
    for i=1:length(x)
        if game==1||game==2
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)));
        elseif game==3||game==4
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)),probests(3,pswitch(i)));
        elseif game==5
            gamma(i)=env.get_gamma(x(i),1);
        elseif game==6
            gamma(i)=env.get_gamma(x(i),0,0);
        end
    end
    avgamma=mean(gamma);
    score=std(gamma)/(betapdf(avgamma,2,2)^2);
    catch err
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


