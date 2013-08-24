fh = figure('Units', 'pixels', ...
    'Position', [100 100 500 375]);
h1=plot(gammas,exp(score));
set(fh, 'color', 'white'); % sets the color to white 
% h3=line([0 0.5],[0.5 0.5]);
set(h1, 'LineStyle', '-', 'LineWidth', 2, 'Color', 'Black');
% set(h3, 'LineStyle', '--', 'LineWidth', 1, 'Color', 'Black');
% set(h1, 'Marker', '.', 'MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 1.0);
set(gca, 'Box', 'off' ); % here gca means get current axis 
% axis( [ 0 650 0.2 1] );
% set(gca, 'TickDir', 'out', 'XTick',0.5,'XTickLabel','m', 'YTick', [0 0.5 1],'FontSize', 13);
xlabel( 'Reward estimate r', 'FontSize', 16 );
ylabel( 'Switching probability q(r)', 'FontSize', 16, 'Rotation', 90 ); 
export_fig images/Methods/logistic.eps -q101
