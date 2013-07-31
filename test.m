[model, sim, env ] = games.get(2,1); % get the game
agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','softmax','temperature',15,'gamma',0.67,'alpha',0.2);
[ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 );
analysis = analyse.inference.maxliksearch_rlalg(trace,env,1,'agenttype','sarsa','policytype','softmax','trials',1);


    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','softmax','temperature',10,'gamma',0.7564,'alpha',0.2154);
    score = agent.imitate_run(trace);