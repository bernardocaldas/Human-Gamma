function [ evaluation ] = evaluate(xid,game,varargin)
% tests top-down method e.g. dominant window gamalysis.
    kwargs = utils.dict(varargin{:});
    numtrials = kwargs.get('numtrials',100);
    evaluatefrom = kwargs.get('evaluatefrom',0); % only evaluate from this point onwards
    maxsteps = kwargs.get('maxsteps',250);
    linewidth = kwargs.get('linewidth',2);
    markersize = kwargs.get('markersize',2);
    fontsize = kwargs.get('fontsize',16);
    width = kwargs.get('width',7);
    [model,sim,env] = games.get(xid,game);

    gammarange = [0,0.9];
    alpharange = [0,1.0];
    epsilonrange = [0,0.2];
    temprange = [0.001,0.01].*10^(2*(game==2 | game==4));
    betarange = [0,1.0];
    thetarange = [0.001,0.002].*10^(2*(game==1 | game==3));
    agenttype = kwargs.get('agenttype','sarsa');
    policytype = kwargs.get('policytype','egreedy');

    randinrange = @(range) (range(2)-range(1))*rand(1) + range(1);
    get_agent = @() agents.discrete.get(agenttype,sim.numstates,sim.numactions,...
            'policytype',policytype,...
            'gamma',randinrange(gammarange),...
            'alpha',randinrange(alpharange),...
            'epsilon',randinrange(epsilonrange),...
            'temperature',randinrange(temprange),...
            'beta',randinrange(betarange),...
            'theta',randinrange(thetarange));

    for i=1:numtrials
        agent = get_agent();
        sim.purge();
%        agent.run(sim,maxsteps);
%        trace = sim.history{1};
        [ trace policytrace ] = analyse.sampling.synthetic_traces(agent,sim,maxsteps);
        summary = analyse.get_summary( game, trace );
        analysis = analyse.gammalysis.dominant_in_window(xid,game,width,trace,env,summary,'evaluatefrom',evaluatefrom);
        truegammas(i) = agent.gamma;
%        alphas(i) = agent.alpha(1); % actually just alpha(1)
%        epsilons(i) = agent.policy.epsilonfunc(1); % actually just epsilon(1)
        meangammas(i) = analysis.meang; % the mean inferred gamma
        try
            stegammas(i) = analysis.steg; % the standard error of the inferred gamma
        catch thrown
            stegammas(i) = nan;
        end
    end
    evaluation.truegammas = truegammas;
%    evaluation.alphas = alphas;
%    evaluation.epsilons = epsilons;
    evaluation.meangammas = meangammas;
    evaluation.stegammas = stegammas;

    plot(truegammas,meangammas,'x','linewidth',linewidth,'markersize',markersize);
    hold on;
    errorbar(truegammas,meangammas,stegammas,'.','linewidth',linewidth,'markersize',markersize);
    plot([0,1],[0,1],'r-','linewidth',linewidth,'markersize',markersize);
    xlim([0,1]);
    ylim([0,1]);
    xlabel('true \gamma','fontsize',fontsize);
    ylabel('inferred \gamma','fontsize',fontsize);
    axis square;
    hold off;
    outdir = '../kesh/analysis/synthetic';
    ofname = sprintf('x%dg%d_%s-%s_eval_windows.eps',xid,game,policytype,agenttype);
    opath = sprintf('%s/%s',outdir,ofname);
    fprintf('Saving to %s...\n',opath);
    saveas(gca,opath,'epsc');
    close all;
end


%%function [r] = randinrange(range)
%%    r = (range(2)-range(1))*rand(1) + range(1);
%%end
