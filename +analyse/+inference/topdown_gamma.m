function [ gamma ] = topdown_gamma(env,game, varrewards,trace,domests,probests)
%GET_X Get the estimate of x at the switching points;
%   Inputs: rewards_visit - Rewards at visit states:
%           domests - Domininant policy at each visit of the visit states

%   pswitch- the index in the sequecence of choice states at which a
%   change happens
%   indices_choice are the indices of the full sequence at which a visit choice
%   state happens. indices_choice(pswitch)=absolute index of switch
%   indices_estimate - the index of the filtered reward that is the
%   current estimate at each visit to a choice state

actions=trace.actions;
states=trace.states(1:end-1);
rewards=trace.rewards;
varrewards=env.varrewards(1:length(states));
visit_reward=states==env.reward_state;
visit_choice=states==env.choice_state;

[pswitch is_up]= analyse.inference.get_switiching_points(domests(1,states==1));
indices=find((actions(visit_reward)==env.reward_action));
indices_choice=find(states==env.choice_state);
indices_estimate=analyse.get_indices_estimate(states,actions,env);
rewards_visit=rewards(visit_reward&(actions==env.reward_action));
if game==5||game==6
    rewards_visit=rewards_visit/max(rewards_visit); %
end
% rewards_visit=varrewards(visit&(actions==env.reward_action));


% x0=1;
% fitnessfn=@(x)get_gamma_gauss(x,pswitch,rewards_visit,indices,env,game,probests,indices_estimate);
% lb=1;
% ub=floor(length(rewards_visit)/10);

x0=[5 0.5 0.01];
fitnessfn=@(x)get_gamma_logistic(x(1),x(2),x(3),pswitch,rewards_visit,env,game,probests,domests(1,states==1),indices_estimate);
lb=[1 0 0.001];
ub=[15 1 0.1];

options = optimoptions('fmincon');
options = optimoptions(options,'UseParallel','always');
options = optimoptions(options,'Algorithm', 'active-set');
problem = createOptimProblem('fmincon','x0',x0,'objective',fitnessfn,'lb',lb,'ub',ub,'options',options);
gs = GlobalSearch('MaxTime',20,'Display','off');
ms = MultiStart('MaxTime',150,'Display','off');
[x,minscore] = run(ms,problem,15);

% [minstds(1) gammas(1)]=get_gamma_gauss(minsigma,pswitch,rewards_visit,env,game,probests,indices_estimate);
[minstds(1) gammas(1)]=get_gamma_logistic(x(1),x(2),x(3),pswitch,rewards_visit,env,game,probests,domests,indices_estimate);


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

function [score, avgamma]=get_gamma_logistic(sigma,m,s,pswitch,rewards_visit,env,game,probests,domests,indices_estimate)
if isnan(sigma)==0&&isnan(m)==0&&isnan(s)==0
    filtered_rewards=analyse.filter_rewards('gauss',sigma,rewards_visit);
    firsts=find(indices_estimate==0);
    indices_estimate(firsts)=1;
    estimates_at_choice=filtered_rewards(indices_estimate);
    estimates_at_choice(firsts)=0;
    score=0;
    if game==1||game==2
        avgamma=env.get_gamma(m,1);
    elseif game==3||game==4
        avgamma=env.get_gamma(m,0,0);
    elseif game==5
        avgamma=env.get_gamma(m,1);
    elseif game==6
        avgamma=env.get_gamma(m,0,0);
    end
    for i=2:length(estimates_at_choice)
        if domests(i-1)==0 %short path
            if isempty(find(pswitch==i))
                score=score+log(1-cdf('logistic',estimates_at_choice(i),m,s));
            else
                score=score+log(cdf('logistic',estimates_at_choice(i),m,s));
            end
        else
            if isempty(find(pswitch==i))
                score=score+log(cdf('logistic',estimates_at_choice(i),m,s));
            else
                score=score+log(1-cdf('logistic',estimates_at_choice(i),m,s));
            end
        end
    end
    if isnan(score)==1
        score=-1e12;
    end
    score=-score - log(betapdf(avgamma,2,2));
else
    score=1e12;
end
end
function [score,avgamma]= get_gamma_gauss(sigma,pswitch,rewards_visit,env,game,probests,indices_estimate)
try
    filtered_rewards=analyse.filter_rewards('gauss',sigma,rewards_visit);
    x=filtered_rewards(indices_estimate(pswitch));
    for i=1:length(x)
        if game==1||game==2||game==5
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)));
        elseif game==3||game==4||game==6
            gamma(i)=env.get_gamma(x(i),probests(2,pswitch(i)),probests(3,pswitch(i)));
        end
    end
    gamma_dir1=gamma(1:2:end);
    gamma_dir2=gamma(2:2:end);
    avgamma=mean(gamma);
    score=(std(gamma_dir1)+std(gamma_dir2))/((betapdf(avgamma,2,2)^2)*std(x));
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


