function [gamma logprob] = generate_synthetic(truegamma)
xid = 2;
methods={'window_smooth','sarsa','qlearn'};
markers = ['x','+','s','d','o'];
cc=lines(10);

for j=1:1
    game = j;
    [model, sim, env ] = games.get(xid,game); % get the game
    
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','softmax','temperature',5,'gamma',truegamma,'alpha',0.2);
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 );
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,1) =templogprob;
    gamma(:,1)=tempgamma;
    
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.2,'gamma',truegamma,'alpha',0.2);
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 )
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,2) =templogprob;
    gamma(:,2)=tempgamma;
    
    agent = agents.discrete.get('qlearn',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.2,'gamma',truegamma,'alpha',0.2);
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 )
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,3) =templogprob;
    gamma(:,3)=tempgamma;
    
    agent = agents.discrete.get('qlearn',env.numstates,env.numactions,'policytype','softmax','temperature',0.2,'gamma',truegamma,'alpha',0.2)
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 )
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,4) =templogprob;
    gamma(:,4)=tempgamma;
    
    %     agent = agents.discrete.get('modelbased',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',0.7)
    %     [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 250 )
    %     [logprob(:,5) gamma(:,5)] =analyse.inference.compare_methods(trace,env,game);
    
end