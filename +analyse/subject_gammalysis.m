function [ collected ] = subject_gammalysis(subjects,games,varargin)
% predicts the gamma of the subject from the choice of action 
% assumes xid=2
% example:
% [ collected ] = analyse.subject_gammalysis([1:9],[1:4],'legloc','southwest')
    orangergb = [254 153 20]/255;
    darkbluergb = [14 32 127]/255;
    lightbluergb = [105 144 163]/255;

    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    fontsize = kwargs.get('fontsize',14);
	fontname = kwargs.get('fontname','arial');
    xid = kwargs.get('xid',2)
    if xid ~= 2
        error('This does not currently support xid~=2');
    end

    width = kwargs.get('width',7);

    for s=1:length(subjects)
        subject = subjects(s);
        for g=1:length(games)
            game = games(g);
			try
		        [ analysis, stem, indir ] = analyse.load_gammalysis(xid,subject,game,width,kwargs);
		        analysis.stem = stem;
		        allanalysis{width,s,g} = analysis;
			end
        end
    end
    outdir = kwargs.get('outdir',indir);
    %%% plot subjects
    for g=1:length(games)
        game = games(g);
        meanrs = [];
        meangs = [];
        errrs = [];
        errgs = [];
        for s=1:length(subjects)
            subject = subjects(s);
            try %XXX not for game 3 at present
                % rewards
                uprs = allanalysis{width,s,g}.uprs;
                downrs = allanalysis{width,s,g}.downrs;
                meanrs(s) = mean([uprs' downrs']);
                errrs(s) = std([uprs' downrs'])/sqrt(length([uprs' downrs']));
            end
            % gammas
			try
		        upgs = allanalysis{width,s,g}.upgs;
		        downgs = allanalysis{width,s,g}.downgs;
			    meangs(s) = mean([upgs downgs]);
			    errgs(s) = std([upgs downgs])/sqrt(length([upgs downgs]));
				if meangs(s) >= 1
					meangs(s) = nan;
					errgs(s) = nan;
				end
			catch
				% ignore data not present
				meangs(s) = nan;
				errgs(s) = nan;
			end
			% ignore values of exactly 1
        end
        try %XXX not for game 3 at present
            % rewards
%%XXX No longer plotting rewards separately
%%            h = errorbar(subjects,meanrs,errrs,'x','color','g');
%%            set(h,'linewidth',3);
%%            legend(gca,h,{'All switches'});
%%            xlabel('subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%            ylabel('reward','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%            ofname = sprintf('g%d_subject_gammalysis_rs.eps',game);
%%            ofpath = sprintf('%s/%s',outdir,ofname);
%%            fprintf('saving to %s...\n',ofpath);
%%            saveas(gca,ofname,'epsc');
%%            hold off;
            collected{g}.meanrs = meanrs;
            collected{g}.errrs = errrs;
        end
%%XXX No longer plotting gammas separately
%%        % gammas
%%        h = errorbar(subjects,meangs,errgs,'x','color','g');
%%        set(h,'linewidth',3);
%%        legend(gca,h,{'All switches'});
%%        ylim([0,1.0]);
%%        xlabel('subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%            ylabel('\gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%        ofname = sprintf('g%d_subject_gammalysis_gs.eps',game);
%%        ofpath = sprintf('%s/%s',outdir,ofname);
%%        fprintf('saving to %s...\n',ofpath)
%%        saveas(gca,ofpath,'epsc')
%%        hold off;
        fprintf('Finished for game %d, total errors = %f\n', game, sum(errgs));
        collected{g}.meangs = meangs;
        collected{g}.errgs = errgs;
    end

    colors = lines(4);
    shift = 1/(length(games)+1);

%%    try %XXX not for game 3 at present
%%        %%% rs
%%        xs = subjects;
%%        for g=1:length(games)
%%            game = games(g);
%%            color = colors(g,:);
%%            meanrs = collected{g}.meanrs;
%%            errrs = collected{g}.errrs;
%%
%%            h1(g) = bar(xs,meanrs,shift,'facecolor',color);
%%            hold on;
%%            h2(g) = errorbar(xs,meanrs,errrs,'kx');
%%            xs = xs + shift;
%%            labs{g} = sprintf('Game %d',game);
%%        end
%%        hold off;
%%        legend(gca,h1,labs);
%%        xlabel('Subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%        ylabel('Predicted \gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%        ofname = sprintf('overall_gammalysis_rs.eps',game);
%%        ofpath = sprintf('%s/%s',outdir,ofname);
%%        fprintf('saving to %s...\n',ofpath)
%%        saveas(gca,ofpath,'epsc')
%%    end

%%    %%% gs (alternative)
%%	figure;
%%    xs = subjects;
%%    sublabs = {}; for s=subjects, sublabs = {sublabs{:} num2str(s)}; end
%%    for g=1:length(games)
%%        game = games(g);
%%        color = colors(g,:);
%%        meangs = collected{g}.meangs;
%%        errgs = collected{g}.errgs;
%%
%%        h1(g) = bar(xs,meangs,shift,'facecolor',color);
%%        hold on;
%%        h2(g) = errorbar(xs,meangs,errgs,'kx');
%%        xs = xs + shift;
%%        labs{g} = sprintf('Game %d',game);
%%    end
%%    hold off;
%%    legend(gca,h1,labs,'fontsize',fontsize,'fontname',fontname,'textcolor',darkbluergb);
%%    xlabel('Subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%    ylabel('Inferred \gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%    set(gca,'xtick',xs+(1+shift)/2);
%%    set(gca,'xticklabel',sublabs);
%%    ofname = sprintf('overall_gammalysis_alt_gs.eps',game);
%%    ofpath = sprintf('%s/%s',outdir,ofname);
%%    fprintf('saving to %s...\n',ofpath)
%%    saveas(gca,ofpath,'epsc')

    %%% gs
	figure;
    xs = subjects/(length(subjects)+1);
	allxs = [];
    sublabs = {};
    for g=1:length(games)
		for s=subjects, sublabs = {sublabs{:} num2str(s)}; end
        game = games(g);
        color = colors(g,:);
        meangs = collected{g}.meangs;
        errgs = collected{g}.errgs;
        % if estimate from single value then errs will be 0 but should be inf
        zeroerrs = find(errgs==0);
        errgs(zeroerrs) = inf;

        h1(g) = bar(xs,meangs,shift*4,'facecolor',color,'edgecolor','none');
        hold on;
        h2(g) = errorbar(xs,meangs,errgs,'kx');
		allxs = [allxs xs];
        xs = xs + 1;
        labs{g} = sprintf('Game %d    ',game);
    end
	sublabs = sublabs
	xs = xs
	lenxs = length(xs)
    hold off;
    legloc = kwargs.get('legloc','southeast');
    legend_h = legend(gca,h1,labs,'location',legloc,'textcolor',darkbluergb,'fontsize',fontsize);
	Pos=get(legend_h,'Position');
	% this is a changes
	set(legend_h,'Position',Pos+[-0.1,0.0,0.1,0]);
    xlabel('Subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
    ylabel('Inferred \gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
    set(gca,'xtick',allxs);
    set(gca,'xticklabel',sublabs);
    ofname = sprintf('overall_gammalysis_gs.eps',game);
    ofpath = sprintf('%s/%s',outdir,ofname);
    fprintf('saving to %s...\n',ofpath)
    saveas(gca,ofpath,'epsc')

end
