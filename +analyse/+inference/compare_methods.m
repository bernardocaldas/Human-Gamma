function [ logprob gamma ] = compare_methods( trace,env,game )
%COMPARE_METHODS Summary of this function goes here
%   Detailed explanation goes here
methods={'window_smooth'}%,'sarsa_softmax','sarsa_egreedy','qlearn_egreedy','qlearn_softmax'};
actions=trace.actions;
states=trace.states;
visit=states==1;
visit=visit(1:end-1);
varrewards=env.varrewards(1:length(states)-1);
rewards = trace.rewards;
lmethods=length(methods);
for i=1:lmethods
    switch methods{i}
        case {'window_smooth','window_best','ratio_smooth','ratio_best'}
            [logprob(i) probests domests]=analyse.inference.topdown_logprob(trace,'method',methods{i});
%             xestimate=analyse.inference.get_x(varrewards,trace,domests);
%             gamma(i)=env.get_gamma(xestimate,0,1);
            gamma(i)=analyse.inference.topdown_gamma(env, varrewards,trace,domests,probests);
        case 'sarsa_egreedy'
            analysis_1 = analyse.inference.maxliksearch_rlalg_global(trace,env,game,'agenttype','sarsa','policytype','egreedy','trials',5);
            [logprob(i) index_1]=max(analysis_1.logprobs);
            gamma(i)=analysis_1.gammas(index_1);
        case 'sarsa_softmax'
            analysis_2 = analyse.inference.maxliksearch_rlalg_global(trace,env,game,'agenttype','sarsa','policytype','softmax','trials',5);
            [logprob(i) index_2]=max(analysis_2.logprobs);
            gamma(i)=analysis_2.gammas(index_2);
        case 'qlearn_egreedy'
            analysis_3 = analyse.inference.maxliksearch_rlalg_global(trace,env,game,'agenttype','qlearn','policytype','egreedy','trials',5);
            [logprob(i) index_3]=max(analysis_3.logprobs);
            gamma(i)=analysis_3.gammas(index_3);
        case 'qlearn_softmax'
            analysis_4 = analyse.inference.maxliksearch_rlalg_global(trace,env,game,'agenttype','qlearn','policytype','softmax','trials',5);
            [logprob(i) index_4]=max(analysis_4.logprobs);
            gamma(i)=analysis_4.gammas(index_4);
        case 'modelbased'
            analysis_5 = analyse.inference.maxliksearch_rlalg(trace,env,game,'agenttype','modelbased','policytype','egreedy','trials',5);
            [logprob(i) index_5]=max(analysis_5.logprobs);
            gamma(i)=analysis_5.gammas(index_5);
            
    end
end

