function [ collated ] = collate_maxliksearch(varargin)
    kwargs = utils.dict(varargin{:});
    indir = kwargs.get('indir','../kesh/analysis/maxliksearch');
    polstrats = {'egreedy', 'softmax', 'qp'};
    valstrats = {'sarsa','qlearn','modelbased'};
    quiet = kwargs.get('quiet',true);
    xids = kwargs.get('xids',2);
    for x=xids, for g=1:4, for s=1:9, for pl=1:length(polstrats), for vl=1:length(valstrats)
        polstrat = polstrats{pl};
        valstrat = valstrats{vl};
        try
            ifname = sprintf('s%d0%dg%d_%s-%s_maxliksearch.mat',x,s,g,polstrat,valstrat);
            ifpath = sprintf('%s%s%s',indir,filesep,ifname);
            load(ifpath);
            if analysis.logprob < 0
                collated.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl} = analysis;
            end
        catch
            if ~quiet
                fprintf('Could not load: %s\n',ifpath);
            end
        end
        clear analysis;
        try
            ifname = sprintf('s%d0%dg%d_%s-%s_maxliksearch_S1.mat',x,s,g,polstrat,valstrat);
            ifpath = sprintf('%s%s%s',indir,filesep,ifname);
            load(ifpath);
            if analysis.logprob < 0
                collated.S1.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl} = analysis;
            end
        catch
            if ~quiet
                fprintf('Could not load: %s\n',ifpath);
            end
        end
        clear analysis;
    end,end,end,end,end
    collated.polstrats = polstrats;
    collated.valstrats = valstrats;
end
