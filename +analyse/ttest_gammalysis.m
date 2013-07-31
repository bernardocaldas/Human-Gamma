function [ collected ] = ttest_gammalysis(subjects,games,varargin)
% collects together the mean gammalysis results and performs a t-test 
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

    width = kwargs.get('width',5);

    for s=1:length(subjects)
        subject = subjects(s);
        for g=1:length(games)
            game = games(g);
			try
		        [ analysis, stem, indir ] = analyse.load_gammalysis(xid,subject,game,width,kwargs);
		        analysis.stem = stem;
		        allanalyses{s,g} = analysis;
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
                uprs = allanalyses{s,g}.uprs;
                downrs = allanalyses{s,g}.downrs;
                meanrs(s) = mean([uprs' downrs']);
                errrs(s) = std([uprs' downrs'])/sqrt(length([uprs' downrs']));
            end
            % gammas
			try
		        upgs = allanalyses{s,g}.upgs;
		        downgs = allanalyses{s,g}.downgs;
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
            collected{g}.meanrs = meanrs;
            collected{g}.errrs = errrs;
        end
        fprintf('Finished for game %d, total errors = %f\n', game, sum(errgs(find(isfinite(errgs)))));
        collected{g}.meangs = meangs;
        collected{g}.errgs = errgs;
        cleanmeangs = meangs(find(isfinite(meangs)));
        collected{g}.popmeang = mean(cleanmeangs);
        collected{g}.poperrg = std(cleanmeangs)/sqrt(length(cleanmeangs));
        justgs(g,:) = meangs;
    end

    for pair=[[1,2]',[3,4]',[1,3]',[2,4]']
        firstgs = justgs(pair(1),:);
        secondgs = justgs(pair(2),:);
        bothfinite = find(isfinite(firstgs) & isfinite(secondgs));
        [H,P] = ttest(firstgs(bothfinite),secondgs(bothfinite));
        fprintf('T-test groups %d and %d with H=%d, and P=%f\n',pair(1),pair(2),H,P);
    end

%%    %%% gs
%%	figure;
%%    colors = lines(4);
%%    shift = 1/(length(games)+1);
%%    xs = subjects/(length(subjects)+1);
%%	allxs = [];
%%    sublabs = {};
%%    for g=1:length(games)
%%		for s=subjects, sublabs = {sublabs{:} num2str(s)}; end
%%        game = games(g);
%%        color = colors(g,:);
%%        meangs = collected{g}.meangs;
%%        errgs = collected{g}.errgs;
%%        % if estimate from single value then errs will be 0 but should be inf
%%        zeroerrs = find(errgs==0);
%%        errgs(zeroerrs) = inf;
%%
%%        h1(g) = bar(xs,meangs,shift*4,'facecolor',color,'edgecolor','none');
%%        hold on;
%%        h2(g) = errorbar(xs,meangs,errgs,'kx');
%%		allxs = [allxs xs];
%%        xs = xs + 1;
%%        labs{g} = sprintf('Game %d  ',game);
%%    end
%%	sublabs = sublabs
%%	xs = xs
%%	lenxs = length(xs)
%%    hold off;
%%    legloc = kwargs.get('legloc','southeast');
%%    legend_h = legend(gca,h1,labs,'location',legloc,'textcolor',darkbluergb);
%%
%%    xlabel('Subject','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%    ylabel('Inferred \gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
%%    set(gca,'xtick',allxs);
%%    set(gca,'xticklabel',sublabs);
%%    ofname = sprintf('overall_gammalysis_gs.eps',game);
%%    ofpath = sprintf('%s/%s',outdir,ofname);
%%    fprintf('saving to %s...\n',ofpath)
%%    saveas(gca,ofpath,'epsc')

end
