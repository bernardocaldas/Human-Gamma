function [ analysis, stem, indir ] = load_gammalysis(xid,subject,game,width,varargin)
    % loads the gammalysis results for experiment, subject and game
    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    indir = kwargs.get('indir','../kesh/analysis/gammalysis');
    stem = analyse.resolve_stem(xid,subject,game);
    ifname = sprintf('%s_w%d',stem,width);
    ifpath = sprintf('%s/%s',indir,ifname);
    fprintf('loading file %s...\n',ifpath);
    output = load(ifpath,'analysis');
    analysis = output.analysis;
end
