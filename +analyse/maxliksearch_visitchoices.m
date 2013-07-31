function [ analysis ] = maxliksearch_visitchoices(subject,game,varargin)
% find the maximum likelihood parameters for subject's experience.
%evalfunc = {'last','gauss','???'}
%for ag=1:length(agenttypes)
%    agenttype = agenttypes{ag};
%    for subject=1:9
%        for game=1:4
%            try
%                analysis = maxliksearch_visitchoices(subject,game,'agenttype',agenttype)
%            end
%        end
%    end
%end
    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    %
    xid = kwargs.get('xid',2); % experimental id:
    if xid ~= 2
        error('Does not currently support this xid')
    end
    % 1: early experiment (varying reward on state 1 action 2)
    % 2: later experiment (varying reward on state 2 action 2)
    %XXX matlab doesn't recognise the package analyse, though it does if eval is used.
    % should be:
    [ trace, env, stem, datadir, summary ] = analyse.load_xdata(xid,subject,game,kwargs);
    % instead use:
    %[ trace, env, stem, indir ] = eval('analyse.load_xdata(xid,subject,game,kwargs)');
    outdir = kwargs.get('outdir','../kesh/analysis/visitchoices');
    trials = kwargs.get('trials',10);

    numstates = kwargs.get('numstates',env.numstates);
    numactions = kwargs.get('numactions',env.numactions);

    fitnessfn = @(x)logprob_gauss(x(1), x(2), x(3), x(4), xid, game, summary);
    xrange = [[0,0.5];[0,0.5];[min(trace.rewards),max(trace.rewards)];[0,length(trace.rewards)]];
    
    for trial=1:trials
        % start somewhere in the range for x0
        x0 =  (xrange(:,2)-xrange(:,1)).*rand(size(xrange,1),1)+xrange(:,1);

        %[x,fval,exitflag] = fminsearch(fitnessfn,x0);
        [x,fval,exitflag] = fminsearchbnd(fitnessfn,x0,xrange);
        analysis.logprobs(trial) = -fval;
        analysis.alphas(trial) = x(1);
        analysis.gammas(trial) = x(2);
        switch agenttype
        case {'sarsa','qlearn'}
            switch policytype
            case 'egreedy'
                analysis.epsilons(trial) = x(3);
            case 'softmax'
                analysis.temperatures(trial) = x(3);
            otherwise
                error('Unrecognised policytype');
            end
        end
        switch agenttype
        case {'sarsalambda'}
            switch policytype
            case 'egreedy'
                analysis.epsilons(trial) = x(3);
            case 'softmax'
                analysis.temperatures(trial) = x(3);
            otherwise
                error('Unrecognised policytype');
            end
            analysis.lambdas(trial) = x(4);
        case {'qp'}
                analysis.betas(trial) = x(3);
        otherwise
            error('Unrecognised agenttype');
        end
    end

    [logprob,ind] = max(analysis.logprobs);
    analysis.logprob = logprob;
    analysis.alpha = analysis.alphas(ind);
    try
        analysis.epsilon = analysis.epsilons(ind);
    end
    try
        analysis.temperature = analysis.temperatures(ind);
    end
    try
        analysis.beta = analysis.betas(ind);
    end
    try
        analysis.lambda = analysis.lambdas(ind);
    end
    % saving results
    if numstates == env.numstates
        ofname = sprintf('%s/%s_maxliksearch.mat',outdir,ofstem);
    else
        ofname = sprintf('%s/%s_maxliksearch_S%d.mat',outdir,ofstem,numstates);
    end
    analysis.tracelen = length(trace.actions);
    analysis.ofstem = ofstem;
    analysis.indir = indir;
    analysis.outdir = outdir;
    fprintf('saving to %s...\n',ofname);
    save(ofname,'analysis');




end

function [ lobprob ] = logprob_gauss(p1,p2,thresh,width,xid,game,summary)
    [ keyvisits ] = kwargs.get_visits(xid,game,trace,'summary',summary,'width',width);
    [logprob] = analyse.logprob_of_visits(trace,keyvisits,p1,p2,thresh) 
end
