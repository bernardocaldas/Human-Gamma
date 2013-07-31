function [ analysis ] = inspect_experience(varargin)
	startstep = 150;
    data = load('../kesh/experiments/all.mat','xids');
	kwargs = utils.dict(varargin{:});
	xids = kwargs.get('xids',2);
    for x=xids
        for g=1:2
			varrs1a1 = [];
			varrs1a2 = [];
			avgvrs1a1 = [];
			avgvrs1a2 = [];
			errvrs1a1 = [];
			errvrs1a2 = [];
            for s=1:9
				try
                    gamedata = data.xids{x}.game{g}.subj{s};
                    states = gamedata.state(startstep:end);
                    actions = gamedata.action(startstep:end);
                    rewards = gamedata.reward(startstep:end);
					switch g
					case {1}
						varrewards = gamedata.r3_game1(startstep:length(gamedata.reward));
						ybnds = [40,90];
					case {2}
						varrewards = gamedata.r3_game2(startstep:length(gamedata.reward));
						ybnds = [0.5,0.8];
					otherwise
						error('Unknown variable for varrewards')
					end
                    s1 = (states(1:end-1) == 1);
                    s2 = (states(1:end-1) == 2);
                    %s3 = (states(1:end-1) == 3);
                    s1a1 = (s1 & (actions == 1));
                    s1a2 = (s1 & (actions == 2));
                    s2a1 = (s2 & (actions == 1));
                    s2a2 = (s2 & (actions == 2));
                    %s3a1 = (s3 & (actions == 1));
                    %s3a2 = (s3 & (actions == 2));
                    s1a1s1 = (s1a1 & (states(2:end) == 1));
                    s1a1s2 = (s1a1 & (states(2:end) == 2));
                    s1a2s1 = (s1a2 & (states(2:end) == 1));
                    s1a2s2 = (s1a2 & (states(2:end) == 2));
                    s2a1s1 = (s2a1 & (states(2:end) == 1));
                    %s3a1s1 = (s3a1 & (states(2:end) == 1));
                    when.s1 = find(s1);
                    when.s2 = find(s2);
                    when.s1a1 = find(s1a1(3:end));
                    when.s1a2 = find(s1a2(3:end));
					varrs1a1 = varrewards(when.s1a1);
					varrs1a2 = varrewards(when.s1a2);
					avgvrs1a1(s) = mean(varrs1a1);
					avgvrs1a2(s) = mean(varrs1a2);
					errvrs1a1(s) = std(varrs1a1)/sqrt(length(varrs1a1));
					errvrs1a2(s) = std(varrs1a2)/sqrt(length(varrs1a2));
				catch
					avgvrs1a1(s) = nan;
					avgvrs1a2(s) = nan;
					errvrs1a1(s) = nan;
					errvrs1a2(s) = nan;
		        end
            end
			%analysis.xid{x}.game{g}.varrs1a1 = varrs1a1;
			%analysis.xid{x}.game{g}.varrs1a2 = varrs1a2;
			analysis.xid{x}.game{g}.avgvrs1a1 = avgvrs1a1;
			analysis.xid{x}.game{g}.avgvrs1a2 = avgvrs1a2;
			analysis.xid{x}.game{g}.errvrs1a1 = errvrs1a1;
			analysis.xid{x}.game{g}.errvrs1a2 = errvrs1a2;
			analysis.xid{x}.game{g}.ybnds = ybnds;
        end
    end
    plot_varrewards(analysis);
end

function [] = plot_varrewards(analysis)

	barwidth = 0.4;
	darkbluergb = [14 32 127]/255;
	lightbluergb = [105 144 163]/255;
	orangergb = [254 153 20]/255;
    colours = lines(4);
    legloc = 'southwest';
	games= [1:2];
    numgames = length(games);
	subjects = [1:9];    
    numsubjects = length(subjects);
	xids = 2
    numexps = length(xids);
	xslft = [1:9]-0.2;
	xsrgt = [1:9]+0.2;
	for x=xids
		for g=games
			figure;
			avgvrs1a1 = analysis.xid{x}.game{g}.avgvrs1a1;
			avgvrs1a2 = analysis.xid{x}.game{g}.avgvrs1a2;
			errvrs1a1 = analysis.xid{x}.game{g}.errvrs1a1;
			errvrs1a2 = analysis.xid{x}.game{g}.errvrs1a2;
			h(1) = bar(xslft,avgvrs1a1,'facecolor',orangergb,'edgecolor','none','barwidth',barwidth);
			hold on;
			h(2) = bar(xsrgt,avgvrs1a2,'facecolor',lightbluergb,'edgecolor','none','barwidth',barwidth);
			h(3) = errorbar(xslft,avgvrs1a1,errvrs1a1,'xk');
			h(4) = errorbar(xsrgt,avgvrs1a2,errvrs1a2,'xk');
            %errorbar(partxs,meanrss1a1,lerrss1a1,uerrss1a1,'k.');
            %errorbar(partxs+1,meanrss1a2,lerrss1a2,uerrss1a2,'k.');
            %errorbar(partxs+2,meanrss2a1,lerrss2a1,uerrss2a1,'k.');
            %errorbar(partxs+3,meanrss2a2,lerrss2a2,uerrss2a2,'k.');
            hold off;
            legend(h(1:2),{'state=1, action=1   ','state=1, action=2   '},'location',legloc);
            xlabel('Subject');
            ylabel('Var. Reward');
			xlim([0.5,9.5]);
			ylim(analysis.xid{x}.game{g}.ybnds);
            title(['Game ' num2str(g)]);
        end
    end
end


