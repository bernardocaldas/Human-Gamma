function [ score ] = agent_fitness2(agenttype,numstates,numactions,trace,varargin)
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
        score=score - 1*log(betapdf(kwargs.get('gamma'),2,2));
    end
end
