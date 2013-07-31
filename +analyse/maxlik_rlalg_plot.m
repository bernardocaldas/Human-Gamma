function [] = maxlik_rlalg_plot(ifname,datadir,varargin)
    addpath('../bernado_rl');
    kwargs = utils.dict(varargin{:});
    markbest = kwargs.get('markbest',true);
    eplogscale = kwargs.get('eplogscale',true);
    ifpath = sprintf('%s/%s',datadir,ifname);
    load(ifpath);
    try
        extraparams = analysis.extraparams;
        extraparamstr = analysis.extraparamstr;
    catch
        extraparams = analysis.epsilon;
        extraparamstr = 'epsilon';
    end
    alphas = analysis.alphas;
    gammas = analysis.gammas;
    minlogprob = min(min(min(analysis.logprobs)));
    maxlogprob = max(max(max(analysis.logprobs)));

    if kwargs.iskey('agenttype')
        agenttype = kwargs('agenttype');
    else
        agenttype = analysis.agenttype;
    end
    if kwargs.iskey('ofstem')
        ofstem = kwargs('ofstem');
    else
        ofstem = analysis.ofstem;
    end

    %% plotting alpha versus gamma
    [A,G] = meshgrid(alphas,gammas);
%%    for e=1:length(extraparams)
%%        extraparam = extraparams(e);
%%        LP(:,:) = analysis.logprobs(e,:,:);
%%        contourf(A,G,LP');
%%        title(sprintf('Logprob for %s agent, \\%s = %.2e',agenttype,extraparamstr,extraparam));
%%        colorbar;
%%        caxis([floor(minlogprob/10)*10,ceil(maxlogprob/10)*10]);
%%        xlabel('\alpha');
%%        ylabel('\gamma');
%%        ofname = sprintf('%s/%s_ag-contours%d.eps',datadir,ofstem,e);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%        % geometric mean probability contours
%%        P = exp(LP/analysis.tracelen);
%%        contourf(A,G,P');
%%        title(sprintf('Geo. mean prob. for %s agent, \\%s = %.2e',agenttype,extraparamstr,extraparam));
%%        colorbar;
%%        caxis([0,exp(maxlogprob/analysis.tracelen)]);
%%        xlabel('\alpha');
%%        ylabel('\gamma');
%%        ofname = sprintf('%s/%s_ag-meanpcontours%d.eps',datadir,ofstem,e);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%    end
    LP(:,:) = max(analysis.logprobs,[],1);
    contourf(A,G,LP');
    title(sprintf('Best logprob for %s agent',agenttype));
    colorbar;
    agrange = kwargs.get('agrange',[floor(min(min(LP))/10)*10,ceil(max(max(LP))/10)*10]);
    caxis(agrange);
    xlabel('\alpha');
    ylabel('\gamma');
    ofname = sprintf('%s/%s_agmax.eps',datadir,ofstem);
    % find the best values
    if markbest
    	hold on;
    	maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(alphas(nearmaxi),gammas(nearmaxj),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');
    % geometric mean probability contours
    P = exp(LP/analysis.tracelen);
    contourf(A,G,P');
    title(sprintf('Best geo. mean prob. for %s agent',agenttype));
    colorbar;
    caxis([exp(agrange(1)/analysis.tracelen),exp(agrange(2)/analysis.tracelen)]);
    xlabel('\alpha');
    ylabel('\gamma');
    ofname = sprintf('%s/%s_agmax-meanp.eps',datadir,ofstem);
    % find the best values
    if markbest
    	hold on;
    	maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(alphas(nearmaxi),gammas(nearmaxj),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');

    %% plotting extra parameter versus gamma
    clear LP;
    [E,G] = meshgrid(extraparams,gammas);
%%    for a=1:length(alphas)
%%        alpha = alphas(a);
%%        LP(:,:) = analysis.logprobs(:,a,:);
%%        contourf(E,G,LP');
%%        title(sprintf('Logprob for %s agent, \\alphas = %.2e',agenttype,alpha));
%%        colorbar;
%%        caxis([floor(minlogprob/10)*10,ceil(maxlogprob/10)*10]);
%%        xlabel(extraparamstr);
%%        if eplogscale
%%            set(gca,'xscale','log');
%%        end
%%        ylabel('\gamma');
%%        ofname = sprintf('%s/%s_eg-contours%d.eps',datadir,ofstem,a);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%        % geometric mean probability contours
%%        P = exp(LP/analysis.tracelen);
%%        contourf(E,G,P');
%%        title(sprintf('Geo. mean prob. for %s agent, \\alphas = %.2e',agenttype,alpha));
%%        colorbar;
%%        caxis([0,exp(maxlogprob/analysis.tracelen)]);
%%        xlabel(extraparamstr);
%%        if eplogscale
%%            set(gca,'xscale','log');
%%        end
%%        ylabel('\gamma');
%%        ofname = sprintf('%s/%s_eg-meanpcontours%d.eps',datadir,ofstem,a);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%    end
    LP(:,:) = max(analysis.logprobs,[],2);
    contourf(E,G,LP');
    title(sprintf('Best logprob for %s agent',agenttype));
    colorbar;
    egrange = kwargs.get('egrange',[floor(min(min(LP))/10)*10,ceil(max(max(LP))/10)*10]);
    caxis(egrange);
    xlabel(extraparamstr);
    if eplogscale
        set(gca,'xscale','log');
    end
    ylabel('\gamma');
    ofname = sprintf('%s/%s_egmax.eps',datadir,ofstem);
    % find the best values
    if markbest
    	hold on;
	    maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(extraparams(nearmaxi),gammas(nearmaxj),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');
    % geometric mean probability contours
    P = exp(LP/analysis.tracelen);
    contourf(E,G,P');
    title(sprintf('Best geo. mean prob. for %s agent',agenttype));
    colorbar;
    caxis([exp(egrange(1)/analysis.tracelen),exp(egrange(2)/analysis.tracelen)]);
    xlabel(extraparamstr);
    if eplogscale
        set(gca,'xscale','log');
    end
    ylabel('\gamma');
    ofname = sprintf('%s/%s_egmax-meanp.eps',datadir,ofstem);
    % find the best values
    if markbest
	hold on;
	maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(extraparams(nearmaxi),gammas(nearmaxj),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');

    % alpha versus additional parameter
    clear LP;
    [A,E] = meshgrid(alphas,extraparams);
%%    for g=1:length(gammas)
%%        gamma = gammas(g);
%%        LP(:,:) = analysis.logprobs(:,:,g);
%%        contourf(A,E,LP); % no need for prime
%%        title(sprintf('Logprob for %s agent, \\%s = %.2e',agenttype,'gamma',gamma));
%%        colorbar;
%%        caxis([floor(minlogprob/10)*10,ceil(maxlogprob/10)*10]);
%%        xlabel('\alpha');
%%        ylabel(extraparamstr);
%%        if eplogscale
%%            set(gca,'yscale','log');
%%        end
%%        ofname = sprintf('%s/%s_ae-contours%d.eps',datadir,ofstem,g);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%        % geometric mean probability contours
%%        P = exp(LP/analysis.tracelen);
%%        contourf(A,E,P); % no need for prime
%%        title(sprintf('Geo. mean prob. for %s agent, \\%s = %.2e',agenttype,'gamma',gamma));
%%        colorbar;
%%        caxis([exp(minlogprob/analysis.tracelen),exp(maxlogprob/analysis.tracelen)]);
%%        xlabel('\alpha');
%%        ylabel(extraparamstr);
%%        if eplogscale
%%            set(gca,'yscale','log');
%%        end
%%        ofname = sprintf('%s/%s_ae-meanpcontours%d.eps',datadir,ofstem,g);
%%        fprintf('saving to %s...\n',ofname);
%%        saveas(gcf,ofname,'epsc');
%%    end
    LP(:,:) = max(analysis.logprobs,[],3);
    contourf(A,E,LP);
    title(sprintf('Best logprob for %s agent',agenttype));
    colorbar;
    aerange = kwargs.get('aerange',[floor(min(min(LP))/10)*10,ceil(max(max(LP))/10)*10]);
    caxis(aerange);
    xlabel('\alpha');
    ylabel(extraparamstr);
    if eplogscale
        set(gca,'yscale','log');
    end
    ofname = sprintf('%s/%s_aemax.eps',datadir,ofstem);
    % find the best values
    if markbest
	hold on;
	maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(alphas(nearmaxj),extraparams(nearmaxi),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');
    % geometric mean probability contours
    P = exp(LP/analysis.tracelen);
    contourf(A,E,P);
    title(sprintf('Best geo. mean prob. for %s agent',agenttype));
    colorbar;
    caxis([exp(aerange(1)/analysis.tracelen),exp(aerange(2)/analysis.tracelen)]);
    xlabel(extraparamstr);
    if eplogscale
        set(gca,'xscale','log');
    end
    ylabel('\gamma');
    ofname = sprintf('%s/%s_aemax-meanp.eps',datadir,ofstem);
    if markbest
	hold on;
	maxrow = sort(max(LP,[],1));
        maxcol = sort(max(LP,[],2));
        nearmax = max(maxrow(end-2),maxcol(end-2));
        [nearmaxi nearmaxj] = find(LP >= nearmax);
        scatter(alphas(nearmaxj),extraparams(nearmaxi),'wo');
        hold off;
    end
    fprintf('saving to %s...\n',ofname);
    saveas(gcf,ofname,'epsc');
end
