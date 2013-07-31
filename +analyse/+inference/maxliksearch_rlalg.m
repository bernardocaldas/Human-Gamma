function [ analysis ] = maxliksearch_rlalg(trace,env,game,varargin)
% find the maximum likelihood parameters for subject's experience.
% example usage (will plot all games and all subjects)
%for subject=1:9
%    for game=1:4
%        try
%            analysis = maxlik_rlalg(subject,game)
%        end
%    end
%end
%
%OR
%
%agenttypes = {'sarsa','qlearn','qp'}
%for ag=1:length(agenttypes)
%    agenttype = agenttypes{ag};
%    for subject=1:9
%        for game=1:4
%            try
%                analysis = maxlik_rlalg(subject,game,'agenttype',agenttype)
%            end
%        end
%    end
%end
    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    %
    xid = kwargs.get('xid',2); % experimental id:
    % 1: early experiment (varying reward on state 1 action 2)
    % 2: later experiment (varying reward on state 2 action 2)
    %XXX matlab doesn't recognise the package analyse, though it does if eval is used.
    % should be:
    stem='';
    % instead use:
%     [ trace, env, stem, indir ] = eval('analyse.load_xdata(xid,subject,game,kwargs)');
    outdir = kwargs.get('outdir','../kesh/analysis/maxliksearch');
    indir = kwargs.get('outdir','../kesh/experiments');
    trials = kwargs.get('trials',1);

    %%% proportion of time in state 1 gives rough indication of policy type
    %%notinstate1 = (trace.states ~= 1);
    %%xlims = [1,ceil(length(notinstate1)/10)*10];

    numstates = kwargs.get('numstates',env.numstates);
    numactions = kwargs.get('numactions',env.numactions);

    if numstates == 1 & numstates < env.numstates
        warning('Setting all states to 1');
        trace.states = ones(1,length(trace.states));
    end

    agenttype = kwargs.get('agenttype','sarsa')
    policytype = kwargs.get('policytype','egreedy')
    analysis.agenttype = agenttype;
	analysis.policytype = policytype;
    switch agenttype
    case {'sarsa','qlearn'}
        ofstem = sprintf('%s_%s-%s',stem,policytype,agenttype);
        switch policytype
        case 'egreedy'
            fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'alpha',x(1),'gamma',x(2),'epsilon',x(3));
            %x0 = [0.1,0.7,0.1];
            x0range = [ [0.05,0.5];[0.2,0.9];[0.05,0.5];];
        case 'softmax'
            fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'alpha',x(1),'gamma',x(2),'temperature',x(3));
            x0range = [ [0.05,0.5];[0.2,0.9];[5 50];];
        otherwise
            error('Unrecognised policytype');
        end
    case {'sarsalambda'}
        ofstem = sprintf('%s_%s-%s',stem,policytype,agenttype);
        switch policytype
        case 'egreedy'
            fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'alpha',x(1),'gamma',x(2),'epsilon',x(3),'lambda',x(4));
            %x0 = [0.1,0.7,0.1];
            x0range = [ [0.05,0.8];[0.2,0.9];[0.05,0.5];[0.1,0.9]];
        case 'softmax'
            fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'alpha',x(1),'gamma',x(2),'temperature',x(3),'lambda',x(4));
            x0range = [ [0.05,0.8];[0.2,0.9];[0.05,0.5];[0.1,0.9]];
        otherwise
            error('Unrecognised policytype');
        end
    case {'modelbased'}
        ofstem = sprintf('%s_%s-%s',stem,policytype,agenttype);
        agent = agents.discrete.get(agenttype, numstates, numactions,'gamma',0,'policytype',policytype);
        switch policytype
        case 'egreedy'
            %fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'theta',x(1),'gamma',x(2),'epsilon',x(3));
            fitnessfn = @(x) agent_fitness_modelbased_eg(agent,trace,x(1),x(2),x(3));
            x0range = [ [5*10^-5,0.001];[0.0,1.0];[0.005,0.5]];
        case 'softmax'
            %fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'policytype',policytype,'theta',x(1),'gamma',x(2),'temperature',x(3));
            fitnessfn = @(x) agent_fitness_modelbased_sm(agent,trace,x(1),x(2),x(3));
            x0range = [ [5*10^-5,0.001];[0.0,1.0];[0.005,0.5]];
        otherwise
            error('Unrecognised policytype');
        end
        if game == 1 || game == 3
            % these games have 100 times the reward values as the others so the theta value should be larger.
            x0range(1,:) = 100*x0range(1,:);
        end
    case {'qp'}
        critictype = kwargs.get('critictype','sarsa')
        ofstem = sprintf('%s_%s-%s',stem,agenttype,critictype);
        fitnessfn = @(x) agent_fitness(agenttype,numstates,numactions,trace,'critictype',critictype,'alpha',x(1),'gamma',x(2),'beta',x(3));
        x0range = [ [0.05,0.8];[0.2,0.9];[0.00001,0.1];];
    	analysis.critictype = critictype;
    otherwise
        error('Unrecognised agenttype');
    end

    options = optimoptions('fmincon');
    options = optimoptions(options,'UseParallel','always');
    options = optimoptions(options,'Display', 'off'); 
    options = optimoptions(options,'Algorithm', 'active-set');
    for trial=1:trials
        tic,fprintf('Running trial %d\n',trial);
        % start somewhere in the range for x0
        x0 =  (x0range(:,2)-x0range(:,1)).*rand(size(x0range,1),1)+x0range(:,1);
        [x,fval,exitflag] = fmincon(fitnessfn,x0,[],[],[],[],x0range(:,1),x0range(:,2),[],options);
%         [x,fval,exitflag] = fminsearch(fitnessfn,x0);
%        [x,fval,exitflag] = utils.fminsearchbnd(fitnessfn,x0,x0range(:,1),x0range(:,2));
        analysis.logprobs(trial) = -fval;
        if strcmp(agenttype,'modelbased')
            analysis.thetas(trial) = x(1);
        else
            analysis.alphas(trial) = x(1);
        end
        analysis.gammas(trial) = x(2);
        if strcmp(agenttype,'qp')
            analysis.betas(trial) = x(3);
        else
            switch policytype
            case 'egreedy'
                analysis.epsilons(trial) = x(3);
            case 'softmax'
                analysis.temperatures(trial) = x(3);
            otherwise
                error(sprintf('Unrecognised policytype: %s',policytype));
            end
        end
        if strcmp(agenttype,'sarsalambda')
            analysis.lambdas(trial) = x(4);
        end
        toc
    end

    [logprob,ind] = max(analysis.logprobs);
    analysis.logprob = logprob;
    try
        analysis.alpha = analysis.alphas(ind);
    catch
        warning('Cannot store best alpha');
    end
    try
        analysis.gamma = analysis.gammas(ind);
    catch
        warning('Cannot store best alpha');
    end
    try
        analysis.epsilon = analysis.epsilons(ind);
    catch
        warning('Cannot store best epsilon');
    end
    try
        analysis.temperature = analysis.temperatures(ind);
    catch
        warning('Cannot store best temperature');
    end
    try
        analysis.beta = analysis.betas(ind);
    catch
        warning('Cannot store best beta');
    end
    try
        analysis.lambda = analysis.lambdas(ind);
    catch
        warning('Cannot store best lambda');
    end
    try
        analysis.theta = analysis.thetas(ind);
    catch
        warning('Cannot store best theta');
    end
    % saving results
    if numstates == env.numstates
%         ofname = sprintf('%s/%s_maxliksearch.mat',outdir,ofstem);
    else
%         ofname = sprintf('%s/%s_maxliksearch_S%d.mat',outdir,ofstem,numstates);
    end
    analysis.tracelen = length(trace.actions);
    analysis.ofstem = ofstem;
    analysis.indir = indir;
    analysis.outdir = outdir;
%     fprintf('saving to %s...\n',ofname);
%     save(ofname,'analysis');

    % plotting
%    analyse.maxlik_rlalg_plot(ofstem,outdir,kwargs)
   fprintf('Logprob = %10.4g\n' , logprob)%
end


function [ score ] = agent_fitness(agenttype,numstates,numactions,trace,varargin)
    %varargin = varargin
    kwargs = utils.dict(varargin{:});
    agent = agents.discrete.get(agenttype, numstates, numactions, varargin{:});
    % score is the negative logprob
    score = -agent.imitate_run(trace);
    if kwargs.iskey('epsilon')
        score=score - 2*log(betapdf(2*kwargs.get('epsilon'),2,2));
    elseif kwargs.iskey('temperature')
        score=score - 2*log(-((kwargs.get('temperature')-25)/25)^2+1);% - betapdf(2*kwargs.get('epsilon',0.1),2,2);
    end
    if kwargs.iskey('alpha')
        score=score -2*log(betapdf(2*kwargs.get('alpha'),2,2));
    end
    if kwargs.iskey('gamma')
        score=score - 2*log(betapdf(kwargs.get('gamma')*1.3,2,2));
    end
end

function [ score ] = agent_fitness_modelbased_sm(agent,trace,theta,gamma,temperature)
    %fprintf('Calling fitness func. ');
    %varargin = varargin
    fprintf('theta=%f',theta);
    agent.theta = theta;
    agent.gamma = gamma;
    agent.policy.tempfunc = @(i) temperature;
    agent.reset();
    % score is the negative logprob
    score = -agent.imitate_run(trace);
end

function [ score ] = agent_fitness_modelbased_eg(agent,trace,theta,gamma,epsilon)
    %fprintf('Calling fitness func. ');
    %varargin = varargin
    fprintf('theta=%f',theta);
    agent.theta = theta;
    agent.gamma = gamma;
    agent.policy.epsilonfunc = @(i) epsilon;
    agent.reset();
    % score is the negative logprob
    score = -agent.imitate_run(trace);
end

