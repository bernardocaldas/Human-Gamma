game=6
trace.states=state'
trace.actions=action'
trace.rewards=reward';
[model, sim, env ] = games.get(2,game,'varrewards',rewards); % get the game
[templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);