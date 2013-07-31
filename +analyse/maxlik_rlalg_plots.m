function [] = maxlik_rlalg_plots(ifnames,datadir,varargin)
% PLOT multple files with the same ranges
%%% example usage:
%%datadir = '../kesh/experiments'
%%S=9
%%G=4
%%for sg=1:S*G
%%    [subject, game] = ind2sub([S,G],sg);
%%    stem = analyse.resolve_stem(xid,subject,game);
%%    files = dir([datadir '/' stem '_*.mat']);
%%    fnames = {};
%%    for f=1:length(files)
%%        fnames{f} = files(f).name;
%%    end
%%    try
%%        analyse.maxlik_rlalg_plots(fnames,datadir)
%%    catch
%%        warning(['Could not process stem ' stem])
%%    end
%%end

    addpath('../bernado_rl')
    kwargs = utils.dict(varargin{:});
    accuracy = kwargs.get('accuracy',10);
    agrange = [inf,-inf];
    egrange = [inf,-inf];
    aerange = [inf,-inf];
    for i=1:length(ifnames)
        ifname = ifnames{i};
        ifpath = sprintf('%s/%s',datadir,ifname);
        load(ifpath);
        AGLP(:,:) = max(analysis.logprobs,[],1);
        thismin = floor(min(min(AGLP))/accuracy)*accuracy;
        thismax = ceil(max(max(AGLP))/accuracy)*accuracy;
        agrange = [min(agrange(1),thismin),max(agrange(2),thismax)];
        EGLP = [];
        EGLP(:,:) = max(analysis.logprobs,[],2);
        thismin = floor(min(min(EGLP))/accuracy)*accuracy;
        thismax = ceil(max(max(EGLP))/accuracy)*accuracy;
        egrange = [min(egrange(1),thismin),max(egrange(2),thismax)];
        AELP = [];
        AELP(:,:) = max(analysis.logprobs,[],3);
        thismin = floor(min(min(AELP))/accuracy)*accuracy;
        thismax = ceil(max(max(AELP))/accuracy)*accuracy;
        aerange = [min(aerange(1),thismin),max(aerange(2),thismax)];
    end
    for i=1:length(ifnames)
        ifname = ifnames{i};
        analyse.maxlik_rlalg_plot(ifname,datadir,kwargs)
    end
end
