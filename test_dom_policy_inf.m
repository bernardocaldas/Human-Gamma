[model, sim, env ] = games.get(2,5,'varrewards',rewards); % get the game
epsilons=[0.1]
for j=1:10;
for i=1:10
    agent = agents.discrete.get('sarsa',env.numstates,env.numactions,'policytype','softmax','temperature',1,'gamma',0.9,'alpha',0.2);
    [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 600 );
    summary=analyse.get_summary(1,trace);
    
    truedom=policytrace(1,1,:)>policytrace(1,2,:);
    truedom=truedom(:)';
    truedom=truedom(summary.binary.s1);
    
    [logprob probests domests]=analyse.inference.topdown_logprob(env,trace,'method','window_smooth');
    
    accuracy(i,j)=mean(domests(1,trace.states(1:end-1)==1)==truedom)
end
end

%     hold on
% %     plt(trace.actions(summary.binary.s1),'r')
%     plot(truedom,'b')
%     plot(domests, 'r')
%     ylim([-0.2 1.2]);

meanaccuracy=mean(accuracy)