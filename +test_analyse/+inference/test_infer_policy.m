function [ ] = test_infer_policy(varargin)
% to generate more data like this:
% xid = 2; game = 1; [model, sim, env ] = games.get(xid,game); % get the game
% agent = agents.discrete.get('sarsa',2,2,'policytype','egreedy','epsilon',0.2,'gamma',0.7,'epsilon',0.2)
% [ trace policytrace ] = analyse.sampling.synthetic_traces( agent, sim, 250 )
% [ summary ] = analyse.get_summary(game, trace )
% xs = summary.binary.s1a1(summary.binary.s1)
% qsext = permute(policytrace(1,1,:),[1,3,2]);
% qs = qsext(summary.binary.s1);
% rs = ???

% simple egreedy (?????)
kwargs = utils.dict(varargin{:});
testname1 = 'egreedy';
q1s = [ 0.5000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.9000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 0.1000 ];
x1s = [ 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ];

% more challenging egreedy (gamma=0.7,alpha=0.3,epsilon=0.2)
testname2 = 'egreedyhard';
x2s = [ 1 1 1 1 0 1 1 1 1 0 1 1 1 1 1 1 0 1 1 1 1 0 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 0 1 1 1 1 0 1 1 1 0 0 1 0 0 0 1 1 1 0 1 1 0 0 1 1 0 0 0 0 1 0 0 1 1 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1 0 0 1 0 1 1 1 1 1 1 1 1 1 0 1 0 1 1 0 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 0 0 1 1 0 1 0 1 1 1 0 1 1 0 1 0 0 0 0 1 1 ];
q2s = [ 0.5000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.2000 0.2000 0.2000 0.8000 0.2000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.2000 0.8000 0.8000 0.8000 0.2000 0.8000 0.8000 0.8000 0.8000 0.2000 0.8000 0.8000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.2000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 0.8000 ];

% straightforward softmax (gamma=0.7,alpha=0.3,temperature=20)
testname3 = 'softmax';
x3s = [ 0 1 1 0 1 1 1 1 1 0 1 0 1 0 1 0 0 1 0 0 1 1 1 1 1 1 1 1 1 1 0 1 0 1 0 1 1 1 1 0 1 1 1 0 1 1 0 0 0 1 1 1 0 0 1 1 0 0 0 1 0 1 1 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 0 0 1 0 1 0 0 1 1 0 1 0 0 1 0 0 1 1 1 1 1 1 0 1 0 1 0 1 1 0 1 0 1 1 0 1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 1 1 0 1 1 1 1 1 1 0 1 1 0 1 1 1 ];
q3s = [ 0.5000 0.4073 0.4073 0.4305 0.3990 0.4943 0.5616 0.6383 0.6884 0.7459 0.6087 0.6998 0.5978 0.6852 0.5945 0.6808 0.5391 0.4954 0.6087 0.4744 0.4551 0.5751 0.6706 0.7438 0.7989 0.8402 0.8709 0.8937 0.9103 0.9222 0.9304 0.8497 0.8580 0.8066 0.8101 0.7661 0.7620 0.7503 0.7325 0.7100 0.6838 0.6561 0.6249 0.5920 0.5913 0.5584 0.5275 0.5406 0.5497 0.5560 0.5286 0.5072 0.4905 0.5068 0.5202 0.5077 0.4974 0.5110 0.5211 0.5281 0.5193 0.5261 0.5177 0.5101 0.5182 0.5239 0.5171 0.5225 0.5154 0.5206 0.5243 0.5269 0.5282 0.5296 0.5306 0.5313 0.5318 0.5414 0.5388 0.5600 0.5272 0.4923 0.4968 0.5008 0.4678 0.4715 0.4748 0.4478 0.4509 0.4312 0.4340 0.4365 0.4235 0.4173 0.4195 0.4191 0.4211 0.4230 0.4290 0.4307 0.4323 0.4469 0.4706 0.4994 0.5196 0.5478 0.5803 0.5651 0.5998 0.5330 0.5803 0.5725 0.6146 0.6520 0.6306 0.6640 0.6423 0.6715 0.6958 0.6702 0.6912 0.7086 0.7229 0.7348 0.7442 0.7511 0.7553 0.7225 0.7240 0.7216 0.7161 0.7084 0.6997 0.6914 0.6847 0.6805 0.6791 0.6624 0.6638 0.6677 0.6727 0.6778 0.6821 0.6854 0.6690 0.6713 0.6724 0.6600 0.6603 0.6594 ];

% challenging softmax (gamma=0.7,alpha=0.3,temperature=15)
testname4 = 'softmaxhard';

compare_all(x1s,q1s,testname1,kwargs);
% compare_all(x2s,q2s,testname2,kwargs);
% compare_all(x3s,q3s,testname3,kwargs);
% compare_all(x4s,q4s,testname4,kwargs);
end


function compare_all(xs,qs,testname,kwargs)
    % the dominant action at each visit.
    doms = qs > 0.5;
    N = length(qs);

    linewidth = 2;
    markersize = 8;
    fontsize = 16;



    %
    %%
    %%%
    %%
    %


    lambda = 5;
    base = 2;
    schemes = {'harmonic','inverse-square','geometric','poisson'};
    colours = colorcube(max(length(schemes)+2,10));
    figure;
    hold on;
    legtext = {'q_i' 'X_i'};


    for s=1:length(schemes)
        [ probests domests ] = analyse.inference.infer_policy(xs,'method','window','scheme',schemes{s},'base',base,'lambda',lambda);
        h(s+2) = plot([1:N],probests,'o-','linewidth',linewidth,'markersize',markersize,'color',colours(s+2,:));
        %legtext{s+2} = [ 'window - ' schemes{s}];
        switch schemes{s}
        case 'geometric'
            legtext{s+2} = sprintf('%s(%.1f)',schemes{s},base);
        case 'poisson'
            legtext{s+2} = sprintf('%s(%.1f)',schemes{s},lambda);
        otherwise
            legtext{s+2} = schemes{s};
        end
        results.probests{s} = probests;
        results.agreement(s) = mean(domests == doms);
    end
    h(1) = plot([1:N],qs,'--','linewidth',linewidth,'color',[0,0,0]);
    h(2) = plot([1:N],xs,'x','linewidth',linewidth,'markersize',markersize,'color',[0.2,0.2,0.2]);
    legend(gca,h, legtext,'location', 'northwest','fontsize',fontsize-2);
    xlabel('visit (i)','fontsize',fontsize);
    ylabel('probability','fontsize',fontsize);
    saveas(gcf,['window-method-predictions_' testname '.eps'],'epsc');


    %probests = analyse.inference.infer_policy(xs,'method','window','scheme',schemes{s},'base',base,'lambda',lambda);
    %plot([1:N],probests,'o-','linewidth',linewidth,'markersize',markersize,'color',colours(s+2,:))
    %results{s} = probests;

    hold off;

    figure;
    hold on;
    agreement = results.agreement;
    for s=1:length(schemes)
        bh(s)  = bar(s,agreement(s),'facecolor',colours(s+2,:));
    end
    set(gca,'xtick',[])
    %set(gca,'xtick',[1:length(schemes)]);
    %set(gca,'xticklabel',legtext{3:end});
    legend(gca,bh,{legtext{3:end}},'location','north','fontsize',fontsize-2); 
    ylim([floor(min(agreement*10))/10,1]);
    xlabel('scheme','fontsize',fontsize);
    ylabel('accuracy','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['window-method-accuracy_' testname '.eps'],'epsc');

    %inspect different values of lambda with poisson scheme
    lambdas = kwargs.get('lambdas',[1:10]);
    for l=1:length(lambdas)
        lambda = lambdas(l);
        [ probests domests ] = analyse.inference.infer_policy(xs,'method','window','scheme','poisson','lambda',lambda);
        lambdaagreement(l) = mean(domests == doms);
        xlabtext{l} = num2str(lambda);
    end
    figure;
    bar([1:length(lambdaagreement)],lambdaagreement');
    set(gca,'xticklabel',xlabtext);
    ylim([floor(min(lambdaagreement*10))/10,1]);
    xlabel('\lambda','fontsize',fontsize);
    ylabel('accuracy','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['poisson-scheme-accuracy_' testname '.eps'],'epsc');

    %inspect different values of base with geometric scheme
    bases = kwargs.get('bases',[1.0001,1.001,1.01,1.1,1.3,1.5,1.8,2.1,2.5,3]);
    for b=1:length(bases)
        base = bases(b);
        [ probests domests ] = analyse.inference.infer_policy(xs,'method','window','scheme','poisson','base',base);
        baseagreement(b) = mean(domests == doms);
        xlabtext{b} = num2str(base);
    end
    figure;
    bar([1:length(baseagreement)],baseagreement');
    set(gca,'xticklabel',xlabtext,'fontsize',fontsize-2);
    ylim([floor(min(baseagreement*10))/10,1]);
    xlabel('base','fontsize',fontsize);
    ylabel('accuracy','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['geometric-scheme-accuracy_' testname '.eps'],'epsc');

    %
    %%
    %%%
    %%
    %
    clear legtext;
    legtext = {'q_i' 'X_i'};
    %inspect different values of k with ratio test
    figure;
    hold on;
    ks = kwargs.get('ks',[0:3,5,7,10]);
    colours = colorcube(max(length(ks)+1,10));
    for ind=length(ks):-1:1
        k = ks(ind);
        [ probests domests ] = analyse.inference.infer_policy(xs,'method','ratio','k',k);
        h(ind+2) = plot([1:N],probests,'-','linewidth',linewidth,'markersize',markersize,'color',colours(ind,:));
        legtext{ind+2} = sprintf('k=%d',k);
        ratioresults.probests{ind} = probests;
        ratioresults.agreement(ind) = mean(domests == doms);
    end
    h(1) = plot([1:N],qs,'--','linewidth',linewidth,'color',[0,0,0]);
    h(2) = plot([1:N],xs,'x','linewidth',linewidth,'markersize',markersize,'color',[0.2,0.2,0.2]);
    legend(gca,h, legtext,'location', 'northwest','fontsize',fontsize-2);
    xlabel('visit (i)','fontsize',fontsize);
    ylabel('probability','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['ratio-method-predictions_' testname '.eps'],'epsc');

    ratioagreement = ratioresults.agreement;
    figure;
    bar([1:length(ratioagreement)],ratioagreement');
    set(gca,'xticklabel',ks);
    ylim([floor(min(ratioagreement*10))/10,1]);
    xlabel('k','fontsize',fontsize);
    ylabel('accuracy','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['ratio-method-accuracy_' testname '.eps'],'epsc');

    %

    %
    %%
    %%%
    %%
    %
    clear legtext;
    legtext = {'q_i' 'X_i'};
    %inspect different values of etas with evidence test
    figure;
    hold on;
    etas = kwargs.get('etas',[0.5,0.6,0.65,0.7,0.75,0.8,0.9]);
    colours = colorcube(max(length(etas)+1,10));
    for ind=length(etas):-1:1
        eta = etas(ind);
        [ probests domests ] = analyse.inference.infer_policy(xs,'method','evidence','eta',eta);
        eh(ind+2) = plot([1:N],probests,'-','linewidth',linewidth,'markersize',markersize,'color',colours(ind,:));
        legtext{ind+2} = sprintf('\\eta=%.1f',eta);
        evidenceresults.probests{ind} = probests;
        evidenceresults.agreement(ind) = mean(domests == doms);
    end
    eh(1) = plot([1:N],qs,'--','linewidth',linewidth,'color',[0,0,0]);
    eh(2) = plot([1:N],xs,'x','linewidth',linewidth,'markersize',markersize,'color',[0.2,0.2,0.2]);
    legend(gca,eh, legtext,'location', 'northwest','fontsize',fontsize-2);
    xlabel('visit (i)','fontsize',fontsize);
    ylabel('probability','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['evidence-method-predictions_' testname '.eps'],'epsc');

    evidenceagreement = evidenceresults.agreement;
    figure;
    bar([1:length(evidenceagreement)],evidenceagreement');
    set(gca,'xticklabel',etas);
    ylim([floor(min(evidenceagreement*10))/10,1]);
    xlabel('\eta','fontsize',fontsize);
    ylabel('accuracy','fontsize',fontsize);
    set(gca,'fontsize',fontsize);
    saveas(gcf,['evidence-method-accuracy_' testname '.eps'],'epsc');

%     close all;

end
