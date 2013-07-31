cc=lines(16);
for g=1:4
    figure;
    hold on
    chance=300*log(0.5);
    chance=ones(1,9)*chance;
    for m=1:2
        plot(loglik(:,g,m),'-x','color',cc(m,:))
    end
    plot(chance,'--b');
    legend('Window Smooth Harmonic','Ratio Smooth Harmonic','Chance')
    title(sprintf('Log-Likelihood for game %d',g))
    xlabel('Subject')
    ylabel('log-likelihood')
%     saveas(gcf,['loglik_' sprintf('s%dg%d',g) '.eps'],'epsc');
    saveas(gcf,['img\inference\methods\game' sprintf('%d',g) '.jpg']);
end
