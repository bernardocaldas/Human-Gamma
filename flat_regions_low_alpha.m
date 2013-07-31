[model, sim, env ] = games.get(2,1); % get the game

agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',0.5,'alpha',0.05);
[ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 );
agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',0.3,'alpha',0.05);
[score3 test3]= agent.imitate_run(trace)
agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',0.8,'alpha',0.05);
[score8 test8]= agent.imitate_run(trace)

hold on
plot(test3(:,3),'b.')
plot(test8(:,3),'b-')
plot(test3(:,4),'c.')
plot(test8(:,4),'c-')
% plot(test8(3,:),'g-')
% plot(test3(3,:),'g.')
% plot(test3(4,:),'c.')
% plot(test8(4,:),'c-')