function [ collated ] = plot_maxliksearch(varargin)
    % plotting best values only
    kwargs = utils.dict(varargin{:});
    xids = kwargs.get('xids',2);
    [ collated ] = analyse.collate_maxliksearch('xids',xids);
    legloc = kwargs.get('legloc','eastoutside');
    outdir = kwargs.get('outdir','../kesh/analysis/maxliksearch');
    polstrats = collated.polstrats;
    valstrats = collated.valstrats;
    numpl = length(polstrats);
    numvl = length(valstrats);
    colours = colorcube(numpl*numvl);
    subjects = [1:9];
    games = kwargs.get('games',1);
    for x=xids, for g=games
        figure;
        for pl=1:numpl, for vl=1:numvl
            polstrat = polstrats{pl};
            valstrat = valstrats{vl};
            for s=subjects
                try
                    %theselogprobs(s) = collated..xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.logprob;
                    % didn't save gamma so now have to find best again
                    potgammas = collated.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.gammas;
                    potinds = find( potgammas > 0 & potgammas < 1);
                    [bestlogprob i] = max(collated.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.logprobs(potinds));
                    theselogprobs(s) = bestlogprob;
                    thesegammas(s) = collated.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.gammas(potinds(i));

                catch
                    theselogprobs(s) = nan;
                    thesegammas(s) = nan;
                end
                try
                    %S1theselogprobs(s) = collated.S1.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.logprob;
                    % didn't save gamma so now have to find best again
                    potgammas = collated.S1.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.gammas;
                    potinds = find( potgammas > 0 & potgammas < 1);
                    [bestlogprob i] = max(collated.S1.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.logprobs(potinds));
                    S1theselogprobs(s) = bestlogprob;
                    S1thesegammas(s) = collated.S1.xid{x}.subject{s}.game{g}.polstrat{pl}.valstrat{vl}.gammas(potinds(i));
                catch
                    S1theselogprobs(s) = nan;
                    S1thesegammas(s) = nan;
                end
            end
            logprobs.polstrat{pl}.valstrat{vl}.xid(x).game(g).subject = theselogprobs;
            gammas.polstrat{pl}.valstrat{vl}.xid(x).game(g).subject = thesegammas;
            ind = sub2ind([numpl,numvl],pl,vl);
            thiscolour = colours(ind,:);
            subplot(2,2,1); hold on;
            h(ind) = plot(subjects,theselogprobs,'x','color',thiscolour);
            legtext{ind} = sprintf('%s-%s   ',polstrat,valstrat);
            h(ind+numpl*numvl) = plot(subjects,S1theselogprobs,'o','color',thiscolour);
            legtext{ind+numpl*numvl} = sprintf('%s-%s (stateless)  ',polstrat,valstrat);
            subplot(2,2,3); hold on;
            h2(ind) = plot(subjects,thesegammas,'x','color',thiscolour);
            
        end,end
        subplot(2,2,3); hold on;
        w= kwargs.get('width',7);
        for s=subjects
            try
                [ gammalysis ] = analyse.load_gammalysis(x,s,g,w);
                allgs = [gammalysis.upgs gammalysis.downgs];
                infgammeans(s) = mean(allgs);
                infgamstes(s) = std(allgs)/sqrt(length(allgs));
            catch
                infgammeans(s) = nan;
                infgamstes(s) = nan;
            end
        end
        errorbar(subjects,infgammeans,infgamstes,'ks');
        subplot(2,2,1); hold on;
        legend(h,legtext,'location',legloc);
        %legend(h,legtext);
    
        hold off;
        ofname = sprintf('opt_maxliksearch_xid%d_game%d.eps');
        ofpath = sprintf('%s/%s',outdir,ofname);
        fprintf('Saving to %s...', ofpath);
        saveas(gcf,ofpath,'epsc');
    end,end

end
