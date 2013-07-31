function [ analysis, summary ] = all_window_width_agreement(xids,games,subjects,varargin)
% compares the inferred policy between different window widths
    addpath('../bernado_rl');
    orangergb = [254 153 20]/255;
    darkbluergb = [14 32 127]/255;
    lightbluergb = [105 144 163]/255;

    kwargs = utils.dict(varargin{:});
    baselinewidth = kwargs.get('baselinewidth',7);
    widths = kwargs.get('widths',[3,5,7,9,11]);
    kwargs('widths') = widths;
    bw = find(baselinewidth == widths);
    outdir = kwargs.get('outdir','../kesh/analysis/gammalysis');

    % plotsettings
    linewidth = kwargs.get('linewidth',3);
    legloc = kwargs.get('legloc','southwest');

    for xid=xids
        for game=games
            figure;
            hold on;
            colours = colorcube(length(subjects)+2);
            for s=1:length(subjects)
                subject = subjects(s);
                try
                    [ analysis, summary ] = analyse.window_width_agreement(xid,game,subject,kwargs);
                    vals = analysis.agreement(bw,:);
                catch
                    vals = NaN(1,length(widths));
                end
                h(s) = plot(widths,vals,'x-','color',colours(s,:),'linewidth',linewidth);
                legtext{s} = sprintf('Subject %d',s);
            end
            xlim([min(widths),max(widths)]);
            ylim([0,1]);
            xlabel('Window width');
            ylabel(sprintf('Fractional agreement with baseline width %d',baselinewidth)); 
            legend(gca,h,legtext,'location',legloc);
            ofpath = sprintf('%s/x%dg%d_window_width_agreement.eps',outdir,xid,game);
            fprintf('saving to %s...\n',ofpath);
            saveas(gcf,ofpath,'epsc');
        end
    end
end

