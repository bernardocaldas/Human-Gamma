function [ ] = all_gammalysis(subjects,games,widths,varargin)
% predicts the gamma of the subject from the choice of action 
% assumes xid=2
% example:
% analyse.all_gammalysis(1,1,[3:2:12],'legloc','southwest','ylim',[0.4,0.7])
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
    for w=1:length(widths)
        width = widths(w);
        for s=1:length(subjects)
            subject = subjects(s);
            for g=1:length(games)
                game = games(g);
                try
                    [ analysis, stem, indir ] = analyse.load_gammalysis(xid,subject,game,width,kwargs);
                    analysis.stem = stem;
                    allanalysis{w,s,g} = analysis;
                end
            end
        end
    end
    outdir = kwargs.get('outdir',indir);

    %%% plot widths
    for s=1:length(subjects)
        subject = subjects(s);
        for g=1:length(games)
            game = games(g);
            meanuprs = [];
            meandownrs = [];
            meanrs = [];
            for w=1:length(widths)
                width = widths(w);
                try %XXX not for game 3 at present
                    % rewards
                    uprs = allanalysis{w,s,g}.uprs;
                    downrs = allanalysis{w,s,g}.downrs;
                    meanuprs(w) = mean(uprs);
                    meandownrs(w) = mean(downrs);
                    meanrs(w) = mean([uprs' downrs']);
                    erruprs(w) = std(uprs)/sqrt(length(uprs));
                    errdownrs(w) = std(downrs)/sqrt(length(downrs));
                    errrs(w) = std([uprs' downrs'])/sqrt(length([uprs' downrs']));
                end
                % gammas
                upgs = allanalysis{w,s,g}.upgs;
                downgs = allanalysis{w,s,g}.downgs;
                meanupgs(w) = mean(upgs);
                meandowngs(w) = mean(downgs);
                meangs(w) = mean([upgs downgs]);
                errupgs(w) = std(upgs)/sqrt(length(upgs));
                errdowngs(w) = std(downgs)/sqrt(length(downgs));
                errgs(w) = std([upgs downgs])/sqrt(length([upgs downgs]));
            end
            try %XXX not for game 3 at present
                % rewards
                h(1) = errorbar(widths,meanuprs,erruprs,'x-','color',orangergb);
                set(h(1),'linewidth',3);
                hold on;
                h(2) = errorbar(widths,meandownrs,errdownrs,'x-','color',lightbluergb);
                set(h(2),'linewidth',3);
                h(3) = errorbar(widths,meanrs,errrs,'x-','color',darkbluergb);
                set(h(3),'linewidth',3);
                legend(gca,h,{'Switch to long','Switch to short','All switches'});
                xlabel('window width'), ylabel('reward');
                ofname = sprintf('%s_gammalysis_rs.eps',allanalysis{1,s,g}.stem);
                ofpath = sprintf('%s/%s',outdir,ofname);
                fprintf('saving to %s...\n',ofpath);
                saveas(gca,ofpath,'epsc');
            end
            hold off;
            % gammas
			markersize = 8;
            h(1) = errorbar(widths,meanupgs,errupgs,'x-.','color',orangergb,'markersize',markersize);
            set(h(1),'linewidth',3);
            hold on;
            h(2) = errorbar(widths,meandowngs,errdowngs,'x:','color',lightbluergb,'markersize',markersize);
            set(h(2),'linewidth',3);
            h(3) = errorbar(widths,meangs,errgs,'x-','color',darkbluergb,'markersize',markersize);
            set(h(3),'linewidth',3);
			if kwargs.iskey('legloc')
	            legend(gca,h,{'Switch to long','Switch to short','All switches'},'location',kwargs('legloc'),'textcolor',darkbluergb);
			else
	            legend(gca,h,{'Switch to long','Switch to short','All switches'});
			end
			if kwargs.iskey('ylim')
		        ylim(kwargs('ylim'));
			else
		        ylim([0,1.0]);
			end
			xlim([min(widths),max(widths)]);
            xlabel('window width','fontsize',fontsize,'fontname',fontname,'color',darkbluergb), ylabel('\gamma','fontsize',fontsize,'fontname',fontname,'color',darkbluergb);
            ofname = sprintf('%s_gammalysis_gs.eps',allanalysis{1,s,g}.stem);
            ofpath = sprintf('%s/%s',outdir,ofname);
            fprintf('saving to %s...\n',ofpath)
            saveas(gca,ofpath,'epsc')
            hold off;
        end
    end
end
