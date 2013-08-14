markers = ['x','+','s','d','o'];
correct_visits=0;
correct_actions=0;
for subject=1:10
    for game=5:6
        [model, sim, env ] = games.get(2,game)
        try
            trace=analyse.load_xdata(2,subject,game);
            %             loglik(subject,game,i)=analyse.inference.topdown_logprob(trace,'method',methods{i})
            %              visit=trace.states(1:end-1)==env.reward_state;
            %              reward_action=visit&(trace.actions==env.reward_action);
            %              correct_visits=correct_visits+sum(visit);
            %              correct_actions=correct_actions+sum(reward_action);
            [logprobr(subject,game,:) gammar(subject,game,:)] =analyse.inference.compare_methods(trace,env,game);
        catch err
            warning('Analysis failed on subject %d, game %d',subject,game)
        end
    end
end