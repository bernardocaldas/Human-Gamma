[model, sim, env ] = games.get(2,1); % get the game
epsilons=linspace(0,0.5,10);
for j=1:10;
for i=1:10
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','egreedy','epsilon',epsilons(j),'gamma',0.7,'alpha',0.2);
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 300 );
    summary=analyse.get_summary(1,trace);
    
    truedom=policytrace(1,1,:)<policytrace(1,2,:);
    truedom=truedom(:)';
    truedom=truedom(summary.binary.s1);
    
    [logprob probests domests]=analyse.inference.topdown_logprob(trace,'method','window_smooth');
    
    accuracy(i,j)=mean(domests==truedom);
end
end

%     hold on
% %     plot(trace.actions(summary.binary.s1),'r')
%     plot(truedom,'b')
%     plot(domests, 'r')
%     ylim([-0.2 1.2]);

meanaccuracy=mean(accuracy)