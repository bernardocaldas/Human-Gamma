markers = ['x','+','s','d','o'];
gameset=[1 3 5 6];
correct_visits=0;
correct_actions=0;
for subject=1:10
    for g=1:length(gameset)
        [model, sim, env ] = games.get(2,gameset(g))
        try
            trace=analyse.load_xdata(2,subject,gameset(g));
            %             loglik(subject,game,i)=analyse.inference.topdown_logprob(trace,'method',methods{i})
            %              visit=trace.states(1:end-1)==env.reward_state;
            %              reward_action=visit&(trace.actions==env.reward_action);
            %              correct_visits=correct_visits+sum(visit);
            %              correct_actions=correct_actions+sum(reward_action);
            [logprobr(subject,game,:) gammar(subject,game,:)] =analyse.inference.compare_methods(trace,env,gameset(g));
        catch err
            warning('Analysis failed on subject %d, game %d',subject,game)
        end
    end
end