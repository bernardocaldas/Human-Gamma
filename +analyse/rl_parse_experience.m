function [ analysis ] = rl_parse_experience(trace,epsilon)
    agent = agents.discrete.get('sarsa',max(trace.states),max(trace.actions),'alpha',0.1,'gamma',0.9,'epsilon',epsilon);
    [logprob] = agent.imitate_run(trace);
    analysis.logprob = logprob;
    analysis.Q = agent.Q;
    analysis.egreedy_policy = agent.policy.weights;
    analysis.egreedy_V = sum(agent.Q.*agent.policy.weights,2);
    analysis.greedy_policy = agent.greedy_policy();
    analysis.greedy_V = sum(agent.Q.*analysis.greedy_policy,2);
    analysis.agent = agent;
end