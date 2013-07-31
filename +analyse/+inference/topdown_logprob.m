function [ logprobability probests domests] = topdown_logprob( trace,varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
states=trace.states;
actions=trace.actions;
kwargs = utils.dict(varargin{:});
probests=[];domests=[];
method = kwargs.get('method','window');
scheme = kwargs.get('scheme','harmonic');
logprobability=0;
probests=zeros(max(states),length(states)-1);
domests=probests;
switch method
    case {'window_smooth','ratio_smooth','evidence'}
        for j=min(states):max(states)
            visit=states==j;
            visit=visit(1:end-1);
            indicator=actions(visit)==1;
            [ tempprobests{j} tempdomests{j} ] = analyse.inference.infer_policy(indicator,'method',method,'scheme',scheme);
            logprobability=logprobability+sum(log(tempprobests{j}.^(indicator)))+sum(log((1-tempprobests{j}).^(1-indicator)));
        end
        index=ones(max(states),1);
        for i=1:length(states)-1
            stindex=logical(ones(max(states),1));
            s=states(i);
            stindex(s)=0;
            probests(s,i)=tempprobests{s}(index(s));
            domests(s,i)=tempdomests{s}(index(s));
            if i~=1
                domests(stindex,i)=domests(stindex,i-1);
                probests(stindex,i)=probests(stindex,i-1);
            end
            
            index(s)=index(s)+1;
        end
    case {'window_best','ratio_best'}
        for k=0:length(states)
            temploglik(k+1)=0;
            m(k+1)=0;
            for j=min(states):max(states)
                visit=states==j;
                visit=visit(1:end-1);
                indicator=actions(visit)==2;
                %Domests and Probests are not being set for the visit state
                [ probests domests ] = analyse.inference.infer_policy(indicator,'method',method,'k',k);
                temploglik(k+1)=temploglik(k+1)+sum(log(probests.^(indicator)))+sum(log((1-probests).^(1-indicator)));
                m(k+1)=m(k+1)+ceil(length(states(visit))/(k+1));
            end
        end
        [aic bestk]=min(-2*temploglik+2*m);
        logprobability=temploglik(bestk);
        bestk-1
end

end


