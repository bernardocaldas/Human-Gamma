function [ logprob, polstates ] = logprob_of_visits(trace,keyvisits,p1,p2,thresh)

% polstate determines whether subject's dominant action is:
%   a1 (in which case Pr(a1|s1) = p1)
%   a2 (in which case Pr(a1|s1) = p2) 
%   neither (in which case Pr(a1|s1) = 0.5)
    polstate = 0;
    firstnonzerovisit = find(keyvisits.varrewests,1);
    logprob = log(0.5^(firstnonzerovisit-1)); % 0.5 probability of choosing until non-zero estimates
    polstates = zeros(1,firstnonzerovisit);
    for i=firstnonzerovisit:keyvisits.numvisits
        if keyvisits.varrewests(i) < thresh
            polstate = 1;
        else
            polstate = 2;
        end
        polstates(i) = polstate;
        logprob = logprob + logprob_choice(keyvisits.choselong(i),polstate,p1,p2);
        %fprintf('keyvisits.varrewests(i) = %d', keyvisits.varrewests(i))
        %fprintf('keyvisits.varrewests(i) < thresh = %d', keyvisits.varrewests(i) < thresh)
    end
end

function [ logprob ] = logprob_choice(choselong,polstate,p1,p2)

    %fprintf('choselong = %d\n', choselong);
    %fprintf('polstate = %d\n', polstate);

    if polstate == 0 % undecided
        logprob = log(0.5);
    elseif polstate == 1 % prefers short
        logprob = log((1-choselong)*p1 + choselong*(1-p1));
    else % if polstate == 1 % prefers long
        logprob = log((1-choselong)*p2 + choselong*(1-p2));
    end
    %fprintf('logprob = %e\n',logprob);
end
