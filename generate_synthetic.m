function [gamma logprob] = generate_synthetic(truegamma)
xid = 2;
methods={'window_smooth','sarsa','qlearn'};
markers = ['x','+','s','d','o'];
cc=lines(10);
gameset=[1]
for j=1:1
    game = gameset(j);
    [model, sim, env ] = games.get(xid,game); % get the game
    if game<5
        length=350;
        temperature=25;
    else
        length=650;
        temperature=1.5;
    end
        
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','softmax','temperature',temperature,'gamma',truegamma,'alpha',0.2,'Q',20*ones(env.numstates,env.numactions));
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, length );
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,1) =templogprob;
    gamma(:,1)=tempgamma;
    
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',truegamma,'alpha',0.4,'Q',20*ones(env.numstates,env.numactions));
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, length);
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,2) =templogprob;
    gamma(:,2)=tempgamma;
    
    agent = agents.discrete.get('qlearn',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',truegamma,'alpha',0.4,'Q',20*ones(env.numstates,env.numactions));
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, length )
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,3) =templogprob;
    gamma(:,3)=tempgamma;
    
    agent = agents.discrete.get('qlearn',env.numstates,env.numactions,'policytype','softmax','temperature',temperature,'gamma',truegamma,'alpha',0.4,'Q',20*ones(env.numstates,env.numactions));
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, length )
    [templogprob tempgamma] =analyse.inference.compare_methods(trace,env,game);
    logprob(:,4) =templogprob;
    gamma(:,4)=tempgamma;
    
    %     agent = agents.discrete.get('modelbased',env.numstates,env.numactions,'policytype','egreedy','epsilon',0.1,'gamma',0.7)
    %     [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 250 )
    %     [logprob(:,5) gamma(:,5)] =analyse.inference.compare_methods(trace,env,game);
    
end
