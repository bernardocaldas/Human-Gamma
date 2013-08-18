function [logprob gamma ] = topdown_hmm(env,game, varrewards,trace)
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

indices_choice=find(states==env.choice_state);
indices_estimate=analyse.get_indices_estimate(states,actions,env);
rewards_visit=rewards(visit_reward&(actions==env.reward_action));
if game==5||game==6
    rewards_visit=rewards_visit/max(rewards_visit); %
end

x0=[5 0.5 0.1,0.2];
fitnessfn=@(x)hmm_logprob(x(1),x(2),x(3),x(4),actions(states==1),rewards_visit,indices_estimate,env,game);
lb=[1 0 0.001 0.1];
ub=[15 1 0.1 0.5];

options = optimoptions('fmincon');
options = optimoptions(options,'UseParallel','always');
options = optimoptions(options,'Algorithm', 'active-set');
problem = createOptimProblem('fmincon','x0',x0,'objective',fitnessfn,'lb',lb,'ub',ub,'options',options);
gs = GlobalSearch('MaxTime',20,'Display','off');
ms = MultiStart('MaxTime',300,'Display','off');
[x,minscore] = run(ms,problem,20);

% [minstds(1) gammas(1)]=get_gamma_gauss(minsigma,pswitch,rewards_visit,env,game,probests,indices_estimate);
[minstds(1) gammas(1)]=hmm_logprob(x(1),x(2),x(3),x(4),actions(states==1),rewards_visit,indices_estimate,env,game);
end

function [logprob gamma]=hmm_logprob(sigma,m,s,p,actions,rewards_visit,indices_estimate,env,game)
if isnan(sigma)==0&&isnan(m)==0&&isnan(s)==0&&isnan(p)==0
filtered_rewards=analyse.filter_rewards('gauss',sigma,rewards_visit);
firsts=find(indices_estimate==0);
indices_estimate(firsts)=1;
estimates_at_choice=filtered_rewards(indices_estimate);
estimates_at_choice(firsts)=0;
emission=[1-p,p;p,1-p];
transition=compute_transition(estimates_at_choice,m,s);
last=[log(emission(1,actions(1)));log(emission(2,actions(1)))];
for i=2:length(indices_estimate)
    delta=transition(:,:,i).*[emission(:,actions(i))';emission(:,actions(i))'];
    last=[last(1)+log((delta(1,1)+delta(2,1)));last(2)+log((delta(1,2)+delta(2,2)))];
end
if game==1||game==2||game==5
        gamma=env.get_gamma(m,1);
    elseif game==3||game==4||game==6
        gamma=env.get_gamma(m,0,0);
end
logprob=-sum(last) - log(betapdf(2*p,2,2))-log(betapdf(gamma,2,2)) ;
else
    logprob=+Inf;
end
end
function transition = compute_transition(estimates_at_choice,m,s)
for i=1:length(estimates_at_choice)
    logistic = cdf('logistic',estimates_at_choice(i),m,s);
    transition(:,:,i)=[1-logistic, logistic;1-logistic,logistic];
end
end
