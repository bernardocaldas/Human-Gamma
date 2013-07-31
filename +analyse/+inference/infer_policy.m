function [ probests domests ] = infer_policy(xs,varargin)
% INFER_POLICY - given sequence of binary observations infer the time varying probability of 1 and dominant bias
%
%   [ probests domests ] = infer_policy(xs)
%   takes:
%   xs - a string of binary random outcomes
%   returns:
%   probests - a probability estimate of the probability of 1 at each time-step
%   domests - an estimate of the dominant bias at each time-step
%
%   to-test:
%   % get binary string xs from known probs qs. Then plot these
%   close all; plot(xs,'b.'), hold on; plot(qs,'gx'), 
%   % now get estimate and plot.
%   [ probest ] = analyse.inference.infer_policy(xs), h = plot(probest,'ms')  
    kwargs = utils.dict(varargin{:});
    method = kwargs.get('method','window'); % can be window, ratio or evidence
    N = length(xs);
    switch method
    case 'window_smooth'
        for i=1:N
            probests(i) = estimate_prob_window_smooth(xs,i,kwargs);
        end
        % predicted dominant
        domests = probests > 0.5;
    case 'ratio_smooth'
        for i=1:N
            domests(i) = estimate_dom_ratio_smooth(xs,i,kwargs);
        end
        % the probability estimates are the two means of the two regions of dominance
        probests([1:N]) = mean(xs(~domests));
        probests(domests) = mean(xs(domests));
    case 'window_best'
        k = kwargs.get('k',2);
        for i=1:N
            probests(i) = estimate_prob_window_k(xs,i,k,kwargs);
        end
        % predicted dominant
        domests = probests > 0.5;
    case 'ratio_best'
        k = kwargs.get('k',2);
        for i=1:N
            domests(i) = estimate_dom_ratio_k(xs,i,k,kwargs);
        end
        % the probability estimates are the two means of the two regions of dominance
        probests([1:N]) = mean(xs(~domests));
        probests(domests) = mean(xs(domests));
    case 'evidence'
        eta = kwargs.get('eta',0.9);
        for i=1:N
            probests(i) = estimate_prob_evidence(xs,i,eta);
        end
        % predicted dominant
        domests = probests > 0.5;
    otherwise
        error('Method not recognised');
    end
end

function estimate = estimate_prob(xs,i,kwargs)
    switch kwargs.get('method')
    case 'window'
        estimate = estimate_prob_window(xs,i,kwargs);
    case 'ratio'
        estimate = estimate_dom_ratio(xs,i,kwargs);
    case 'evidence'
        estimate = estimate_prob_evidence(xs,i,kwargs);
    otherwise
        error('Method not recognised');
    end
end

function estimate = estimate_prob_window_smooth(xs,i,kwargs)
    % takes the weighted average estimate for a variety of window sizes (weights depend on scheme).
    N = length(xs);
    mink = 0;
    maxk = max(i-1,N-i);
    for k=mink:maxk
        qhats(k-mink+1) = mean(xs(max(1,i-k):min(N,i+k)));
    end
    kwargs('normalise') = true;
    all_weights = all_prior_weights(mink,maxk,kwargs);
    estimate = sum(all_weights.*qhats);
end

function [ dominant qratio ] = estimate_dom_ratio_smooth(xs,i,kwargs)
    % compares the evidence for q<1/2 with evidence for q>1/2 
%     N = length(xs);
%     xwindow = xs(max(1,i-k):min(N,i+k));
%     qindicator = sum(xwindow*log(3/8) + (1-xwindow)*log(1/8)) - sum(xwindow*log(1/8) + (1-xwindow)*log(3/8));
%     dominant = qindicator > 0;
    
    N = length(xs);
    mink = 0;
    maxk = max(i-1,N-i);
    for k=mink:maxk
        xwindow = xs(max(1,i-k):min(N,i+k));
        qindicator = sum(xwindow*log(3/8) + (1-xwindow)*log(1/8)) - sum(xwindow*log(1/8) + (1-xwindow)*log(3/8));
        dominantk(k-mink+1) =qindicator>0;
    end
    kwargs('normalise') = true;
    all_weights = all_prior_weights(mink,maxk,kwargs);
    dominant = logical(majority(dominantk,all_weights));
end
function [estimate,k] = estimate_prob_window_k(xs,i,k,kwargs)
    % takes the weighted average estimate for a variety of window sizes (weights depend on scheme).
    N = length(xs);
    qhats = mean(xs(max(1,i-k):min(N,i+k)));
    estimate = qhats;
end

function [ dominant qratio k] = estimate_dom_ratio_k(xs,i,k,kwargs)
%     compares the evidence for q<1/2 with evidence for q>1/2 
    N = length(xs);
    xwindow = xs(max(1,i-k):min(N,i+k));
    qindicator = sum(xwindow*log(3/8) + (1-xwindow)*log(1/8)) - sum(xwindow*log(1/8) + (1-xwindow)*log(3/8));
    dominant = qindicator > 0;
end
function estimate = estimate_prob_evidence(xs,i,eta)
    % partial evidence method using fractional beta powers
    N = length(xs);
    powers = [i-1:-1:0 1:N-i];
    alphai = sum(eta.^powers.*xs)+1;
    betai = sum(eta.^powers.*(1-xs))+1;
    estimate = alphai/(alphai+betai);
end


%%function estimate = estimate_prob(xs,i,N,frequentist, kwargs)    
%%    if nargin < 4
%%        frequentist = false;
%%    end
%%    maxk = min(i-1,N-i);
%%    estimate = 0;
%%    mink = -i+1;
%%    maxk = N-i;
%%    if frequentist
%%        %fprintf('Frequentist approach\n');
%%        all_weights = all_prior_weights(mink,maxk,true);
%%        estimate = sum(xs.*all_weights);
%%    else
%%        %fprintf('Bayesian approach\n');
%%        all_weights = all_prior_weights(mink,maxk,false);
%%        posevidence = sum(xs.*all_weights);
%%        negevidence = sum((1-xs).*all_weights);
%%        estimate = (posevidence+0.5)/(posevidence+negevidence+1);
%%    end
%%end

function all_weights = all_prior_weights(mink,maxk,kwargs)
    switch kwargs.get('scheme','harmonic')
    case 'harmonic'
        weightfn = @(k) 1/(k+1);
    case 'inverse-square'
        weightfn = @(k) 1/(k+1)^2;
    case 'inverse-log'
        weightfn = @(k) 1/log(k+1); 
    case 'inverse-sqr'
        weightfn = @(k) 1/((k+1)^0.5); 
    case 'geometric'
        base = kwargs.get('base',2);
        weightfn = @(k) 1/base^k;
    case 'poisson'
        lambda = kwargs.get('lambda',10);
        explambda = exp(lambda);
        weightfn = @(k) explambda*lambda^k/factorial(k);
    otherwise
        error('Weighting scheme not recognised');
    end
    for k=mink:maxk
        all_weights(k-mink+1) = weightfn(k);
    end
    if kwargs.get('normalise',true)
        all_weights = all_weights/sum(all_weights);
    end
end

function weight = prior_weight_exp(k,a)
    % k weighted proportional to 2^{-k} so weights for k=1,2,...i propto 1/2, 1/4, 1/2^i
    % sum of above seq to infinity is 2, sum from point maxk+1 to infinity is 2/2^{maxk+1}. Sum upto k is 2*(1-1/2^{maxk+1})
    %                  2^{-k}
    % prior p(k) = ------------------
    %              2*(1-1/2^(maxk+1))
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%if k > maxk
    %%   error(sprintf('window width (2k+1 for k=%d) too width for i %d in %d points',k,i,N));
    %%end
    %%sumterms = 2*(1-1/2^(maxk+1));
    %%weight = 2^(-k)/sumterms;
    weight = a^(-abs(k));
end

function weight = prior_weight_harmonic(k)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%harmnum = harmonic_number(k+1,1);
    %%weight = 1/(2*(k+1)+1)/harmnum;
    weight = 1/(abs(k)+1);
end

function weight = prior_weight_squares(k)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%harmnum = harmonic_number(k+1,1);
    %%weight = 1/(2*(k+1)+1)/harmnum;
    weight = 1/(abs(k)+1)^2;
end

function weight = prior_weight_uniform(k)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%weight = 1/maxk;
    weight = 1;
end

function weight = repeat_prior_weight_exp(k,maxabsk)
    % k weighted proportional to 2^{-k} so weights for k=1,2,...i propto 1/2, 1/4, 1/2^i
    % sum of above seq to infinity is 2, sum from point maxk+1 to infinity is 2/2^{maxk+1}. Sum upto k is 2*(1-1/2^{maxk+1})
    %                  2^{-k}
    % prior p(k) = ------------------
    %              2*(1-1/2^(maxk+1))
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%if k > maxk
    %%   error(sprintf('window width (2k+1 for k=%d) too width for i %d in %d points',k,i,N));
    %%end
    %%sumterms = 2*(1-1/2^(maxk+1));
    %%weight = 2^(-k)/sumterms;
    weight = (maxabsk-abs(k)+1)*2^(-abs(k));
end

function weight = repeat_prior_weight_harmonic(k,maxabsk)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%harmnum = harmonic_number(k+1,1);
    %%weight = 1/(2*(k+1)+1)/harmnum;
    weight = (maxabsk-abs(k)+1)/(abs(k)+1);
end

function weight = repeat_prior_weight_squares(k,maxabsk)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%harmnum = harmonic_number(k+1,1);
    %%weight = 1/(2*(k+1)+1)/harmnum;
    weight = (maxabsk-abs(k)+1)/(abs(k)+1)^2;
end

function weight = repeat_prior_weight_uniform(k,maxabsk)
    %%XXX no longer summing terms in advance
    %%maxk = min(i-1,N-i);
    %%weight = 1/maxk;
    weight = maxabsk-abs(k)+1;
end


function harmnum = harmonic_number(N,step)
    if nargin < 2
        step = 1;
    end
    harmnum = 0;
    for i=1:step:N
        harmnum = harmnum + 1/i;
    end
end

function [value,vote] = majority(t1,w)
% MAJORITY: returns weighted majority vote for a *row vector*
% [value,vote] = majority1(t1,w)
%	t1    - the data, *must be a row vector*
%	w     - the weight vector, if omitted equal weights
%	value - the result (e.g. majority([1 1 2 3]) = 1)
%	vote  - the vote supporting the result (for above example, vote = 2)

[d,n] = size(t1);
if (nargin==1)
    w=ones(1,n);
end

if(d~=1)
    error('row vectors only !');
end

a = +min(t1);
b = +max(t1);
value = 0;
vote=0;
for i=a:b,
    myvote = sum((t1==i).*w);
    if (myvote>vote)
        vote=myvote;
        value=i;
    end
end
end

