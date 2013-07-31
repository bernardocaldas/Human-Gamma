function [ results, collated ] = plot_maxliksearch_comparison(varargin)
    % plotting best values only
    kwargs = utils.dict(varargin{:});
    xids = kwargs.get('xids',2);
    subjects = kwargs.get('subjects',[1:9]);
    games = kwargs.get('games',[1:4]);
    maxtemp = kwargs.get('maxtemp',10);
    [ collated ] = analyse.collate_maxliksearch('xids',xids);
    legloc = kwargs.get('legloc','eastoutside');
    xrange = [min(subjects)-0.5,max(subjects)+0.5];
    fontsize = kwargs.get('fontsize',14);
    outdir = kwargs.get('outdir','../kesh/analysis/maxliksearch');
    if kwargs.iskey('toplot')
        toplot = kwargs('toplot')
    else
        toplot = [  1 % logprob
                    1 % gamma
                    0 % alpha
                    0 % epsilon
                    0 % temperature
                    0 % beta
                    0 % theta
                    ];
    end
    numplots = sum(toplot);

    if kwargs.iskey('comparing')
        comparing = kwargs('comparing');
    else
        comparing{1}.polstrat = 'softmax';
        comparing{1}.valstrat = 'qlearn';
        comparing{1}.isS1 = false;
        comparing{1}.markertype = 'x';
        comparing{2}.polstrat = 'egreedy';
        comparing{2}.valstrat = 'sarsa';
        comparing{2}.isS1 = false;
        comparing{2}.markertype = '+';
        comparing{3}.polstrat = 'softmax';
        comparing{3}.valstrat = 'qlearn';
        comparing{3}.isS1 = true;
        comparing{3}.markertype = 'o';
        comparing{4}.polstrat = 'egreedy';
        comparing{4}.valstrat = 'modelbased';
        comparing{4}.isS1 = false;
        comparing{4}.markertype = '*';
%        comparing{4}.polstrat = 'softmax';
%        comparing{4}.valstrat = 'qlearn';
%        comparing{4}.isS1 = true;
%XXX for when we have model based and hybrid agents.
%        comparing{3}.polstrat = 'softmax';
%        comparing{3}.valstrat = 'modelbased';
%        comparing{3}.isS1 = false;
%        comparing{4}.polstrat = 'softmax';
%        comparing{4}.valstrat = 'hybrid';
%        comparing{4}.isS1 = false;
    end
    numcmp = length(comparing);
    %colours = colorcube(numcmp);
    colours = lines(numcmp);
    for xid=xids, for game=games
        figure;
        % First we plot the gammalysis top down results (if plotting gamma)
        if toplot(2) % gammas
            %XXX needs neatening up
            %% plotting top down gammalysis
            w= kwargs.get('width',7);
            for s=subjects
                try
                    [ gammalysis ] = analyse.load_gammalysis(xid,s,game,w);
                    allgs = [gammalysis.upgs gammalysis.downgs];
                    infgammeans(s) = mean(allgs);
                    infgamstes(s) = std(allgs)/sqrt(length(allgs));
                catch
                    infgammeans(s) = nan;
                    infgamstes(s) = nan;
                end
            end
            subplot(numplots,1,2);
            hold on;
            errorbar(subjects,infgammeans,infgamstes,'ks');
            hold off
            %XXX needs neatening up
        end
        for cmp=1:numcmp
            polstrat = comparing{cmp}.polstrat;
            pl = find(strcmp(polstrat,collated.polstrats));
            valstrat = comparing{cmp}.valstrat;
            vl = find(strcmp(valstrat,collated.valstrats));
            isS1 = comparing{cmp}.isS1;

            allxvals = [];
            alllps = [];
            allgammas = [];
            allalphas = [];
            alleps = [];
            alltemps = [];
            allbetas = [];
            allthetas = [];
            for s=subjects
            try
                if isS1
                    analysis = collated.S1.xid{xid}.subject{s}.game{game}.polstrat{pl}.valstrat{vl};
                else
                    analysis = collated.xid{xid}.subject{s}.game{game}.polstrat{pl}.valstrat{vl};
                end % if - isS1
                %%% determine rational results from the finsearch algorithm
                %%% log probabilities
                potlps = analysis.logprobs;
                possibles = isfinite(potlps);
                %%% gammas
                potgammas = analysis.gammas;
                possibles = possibles & potgammas > 0 & potgammas < 1;
                %%% alphas
                if any(strcmp(valstrat,{'sarsa','qlearn'}))
                    potalphas = analysis.alphas;
                    possibles = possibles & potalphas > 0 & potalphas < 1;
                end
                %%% (egreedy) epsilons
                if strcmp(polstrat,'egreedy')
                    poteps = analysis.epsilons;
                    possibles = possibles & poteps > 0 & poteps < 0.5;
                end
                %%% (softmax) temperatures
                if strcmp(polstrat,'softmax')
                    pottemps = analysis.temperatures;
                    %XXX Added upper bound on temperature
                    possibles = possibles & pottemps > 0 & pottemps < maxtemp;
                end
                %%% (actor-critic) betas
                if strcmp(polstrat,'qp')
                    potbetas = analysis.betas;
                    %XXX Added upper bound on temperature
                    possibles = possibles & potbetas > 0;
                end
                %%% policy evaluation thetas
                if strcmp(valstrat,'modelbased')
                    potthetas = analysis.thetas;
                    possibles = possibles & potthetas > 0;
                end
                % use the possibles boolean vector to determine which of
                possinds = find(possibles);
                numposs = length(possinds);
                allxvals = [ allxvals s*ones(1,numposs)];

                %%% log probabilities
                lps = analysis.logprobs(possinds);
                alllps = [alllps lps];
                results{s}.lps = lps;
                %%% gammas
                gammas = analysis.gammas(possinds);
                allgammas = [allgammas gammas];
                results{s}.gammas = gammas;
                %%% alphas
                if any(strcmp(valstrat,{'sarsa','qlearn'}))
                    alphas = potalphas(possinds);
                    results{s}.alphas = alphas;
                    allalphas = [allalphas alphas];
                end
                %%% epsilons
                if strcmp(polstrat,'egreedy')
                    eps = poteps(possinds);
                    results{s}.eps = eps;
                    alleps = [alleps eps];
                end
                %%% temperatures
                if strcmp(polstrat,'softmax')
                    temps = pottemps(possinds);
                    results{s}.temps = temps;
                    alltemps = [alltemps temps];
                end
                %%% betas
                if strcmp(valstrat,'modelbased')
                    thetas = potthetas(possinds);
                    results{s}.thetas = thetas;
                    allthetas = [allthetas thetas];
                end
                %%% thetas
                if strcmp(polstrat,'qp')
                    betas = potbetas(possinds);
                    results{s}.betas = betas;
                    allbetas = [allbetas betas];
                end

            catch thrown
                fprintf('Failed with errormessage %s\n', thrown.message());
                theselogprobs(s) = nan;
                thesegammas(s) = nan;
            end % try/catch

            clear possibles
            end % subjects
            %% plotting
            subploti = 1;
            legtxt{cmp} = sprintf('%s-%s',polstrat,valstrat);
            markertype = comparing{cmp}.markertype;
            if toplot(1)
                fprintf('Plotting log-probs...');
                %%% log probabilities
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,alllps,markertype,'color',colours(cmp,:));
                ylabel('log-prob','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(1);
            if toplot(2)
                fprintf('Plotting gammas...');
                %%% gammas
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,allgammas,markertype,'color',colours(cmp,:));
                ylabel('\gamma','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(2);
            %%% alphas
            if toplot(3) & any(strcmp(valstrat,{'sarsa','qlearn'}))
                fprintf('Plotting alphas...');
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,allalphas,markertype,'color',colours(cmp,:));
                ylabel('\alpha','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(3);
            %%% epsilons
            if toplot(4) & strcmp(polstrat,'egreedy')
                fprintf('Plotting epsilons...');
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,alleps,markertype,'color',colours(cmp,:));
                ylabel('\epsilon','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(4);
            %%% temperatures
            if toplot(5) & strcmp(polstrat,'softmax')
                fprintf('Plotting temperatures...');
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,alltemps,markertype,'color',colours(cmp,:));
                ylabel('temp.','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(5);
            %%% thetas
            if toplot(6) & strcmp(valstrat,'modelbased')
                fprintf('Plotting thetas...');
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,allthetass,markertype,'color',colours(cmp,:));
                ylabel('\thetas','fontsize',fontsize);
                set(gca,'fontsize',fontsize);
                hold off;
            end
            subploti = subploti+toplot(6);
            %%% betas
            if toplot(7) & strcmp(polstrat,'qp')
                fprintf('Plotting betas...');
                sph(subploti) = subplot(numplots,1,subploti);
                hold on;
                h(subploti,cmp) = plot(allxvals,allbetas,markertype,'color',colours(cmp,:));
                ylabel('\beta','fontsize',fontsize)
                set(gca,'fontsize',fontsize);
                hold off;
            end
        
        end % for comparision choices

        if toplot(1)
            % add chance line on plot
            basicchance = log(0.5)*250;
            subplot(numplots,1,1);
            hold on;
            plot(xrange,[basicchance basicchance],'k:');
            [ topdownlps ] = get_topdownlps(xid,game,kwargs);
            topdownhand = plot(subjects,topdownlps,'kv');
            yrange = ylim();
            yrange(1) = floor(min(min(alllps),basicchance)/20)*20;
            ylim(yrange);
            hold off;
        end
        subploti = subploti+toplot(7);
        midploti = ceil(numplots/2);
        midplot = subplot(numplots,1,midploti);
        legtxt{end+1} = 'top-down';
        legend([h(midploti,:) topdownhand],legtxt,'location','eastoutside','fontsize',fontsize);
        % midpos - [left bottom width height]
        midpos = get(sph(midploti),'position')
        newwidth = midpos(3);
        allsubjects = [min(subjects):max(subjects)];
        for i=1:numplots
            set(sph(i),'xtick',allsubjects);
            set(sph(i),'xticklabel',num2str(allsubjects'));
            xlim(sph(i),xrange);
            pos = get(sph(i),'position');
            pos(3) = newwidth;
            set(sph(i),'position',pos);
            xrange = xrange
        end;
        xlabel(sph(numplots),'subject','fontsize',fontsize);
        ofname = sprintf('x%dg%d_maxliksearch_comparisons.eps',xid,game);
        ofpath = sprintf('%s/%s',outdir,ofname);
        fprintf('Saving to %s...\n', ofpath);
        saveas(gcf,ofpath,'epsc');

        results{cmp}.allxvals = allxvals;
        results{cmp}.alllps = alllps;
        results{cmp}.allgammas = allgammas;
        results{cmp}.allalphas = allalphas;
        results{cmp}.alleps = alleps;
        results{cmp}.alltemps = alltemps;
        results{cmp}.allbetas = allbetas;
        results{cmp}.allthetas = allthetas;
    end,end

end

function [ topdownlps ] = get_topdownlps(xid,game,kwargs)
    for subject=kwargs.get('subjects',[1:9])
        try
            [ analysis, summary ] = analyse.window_width_agreement(xid,game,subject,kwargs);
            s1 = summary.binary.s1;
            s1a1 = summary.binary.s1a1;
            s1a2 = summary.binary.s1a2;
            pol1 = analysis.polprofiles{kwargs.get('width',7)};
            pol1a1 = sum(pol1 & s1a1);
            pol1a2 = sum(pol1 & s1a2);
            pol2a1 = sum(~pol1 & s1a1);
            pol2a2 = sum(~pol1 & s1a2);
            nums2a1 = sum(summary.binary.s2a1);
            nums2a2 = sum(summary.binary.s2a2);
            numgood = max(nums2a1,nums2a2); % number of times good action performed in other states
            numbad = min(nums2a1,nums2a2); % number of times bad action performed in other states
            if game==3 | game == 4
                nums3a1 = sum(summary.binary.s3a1);
                nums3a2 = sum(summary.binary.s3a2);
                numgood = numgood + max(nums3a1,nums3a2); % number of times good action performed in other states
                numbad = numbad + min(nums3a1,nums3a2); % number of times bad action performed in other states
            end
            fitness = @(ep) -pol1a1*log(1-ep(1))-pol1a2*log(ep(1))-pol2a1*log(1-ep(2))-pol2a2*log(ep(2))-numgood*log(1-ep(3))-numbad*log(ep(3));
            [ epstar invlp ] = utils.fminsearchbnd(fitness,[0.1,0.1,0.1]',[0,0,0]',[0.5,0.5,0.5]');
            % we now need to consider the other parameters too.
            topdownlps(subject) = -invlp;
        catch thrown
            fprintf('Failed to find topdownlps for subject %d, game %d, xid %d\n',subject,game,xid);
            fprintf('Error message: %s',thrown.message());
            topdownlps(subject) = nan;
        end % try/catch
    end % for
end % function
