function [ keyvisits, summary ] = get_visits(xid,game,trace,varargin)
% GET_VISITS - gets the key visits (i.e. to the state (1) in which agent chooses long or short path
    kwargs = utils.dict(varargin{:});
    if kwargs.iskey('summary')
        summary = kwargs('summary');
    else
        summary = analyse.get_summary(game,trace);
    end

    switch kwargs.get('estfunc','last')
    case 'last'
        estfunc = @(rs) estfunc_last(rs);
    case 'gauss'
        estfunc = @(rs) estfunc_gauss(rs,kwargs.get('width',1));
    end
    keyvisits.whenchoice = summary.when.s1;
    keyvisits.choselong = summary.binary.s1a1(summary.when.s1);
    switch xid
    case 2
        switch game
        case {1,2}
            keyvisits.whenvarreward = summary.when.s2a1s1;
        case 3
            keyvisits.whenvarreward = summary.when.s3a2s1;
        case 4
            keyvisits.whenvarreward = summary.when.s3a1s1;
        otherwise
            error(sprintf('game = %d, not supported for xid = %d',game,xid));
        end
    otherwise
        error(sprintf('xid = %d, not supported',game));
    end
    remchoiceinds = keyvisits.whenchoice;
    remvarrinds = keyvisits.whenvarreward;
    varrewlist = [];
    varrewests = [];
    for t=1:remchoiceinds(end)
        if t == remchoiceinds(1)
            try
                varrewests(end+1) = estfunc(varrewlist);
            catch
                warning('Cannot call est func on varrewests');
                varrewests(end+1) = 0;
            end
            remchoiceinds = remchoiceinds(2:end);
        end
        if t == remvarrinds(1)
            varrewlist(end+1) = trace.rewards(remvarrinds(1));
            remvarrinds = remvarrinds(2:end);
        end
    end
    keyvisits.varrewests = varrewests;
    keyvisits.numvisits = length(keyvisits.whenchoice);
end

function [ est ] = estfunc_last(rs)
    if ~isempty(rs)
        est = rs(end);
    else
        est = 0;
    end
end

function [ est ] = estfunc_gauss(rs,width)
    lenrs = length(rs);
    inds = [lenrs:-1:1];
    weights = exp(inds./2/width^2);
    est = sum(weights.*rs(inds))/sum(weights);
end
