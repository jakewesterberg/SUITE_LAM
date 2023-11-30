function PLOT_PSD(PSD_in, fr, f, ax)

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

nele = size(PSD_in,1);
PSD_in = SMOOTH_D1(PSD_in');
PSD_in = SMOOTH_D1(PSD_in');
fr = linspace(fr(1), fr(end), size(PSD_in,1));

imagesc(fr, 1:size(PSD_in,1), PSD_in)

c1 = colorbar;
xlabel('f (Hz)');
ylabel('Lower<-Cx (Depth)->Upper');
title('PSD Difference Across Depth');

for i = 1 : nele
    labels{i} = num2str(i);
end

set(gca,'linewidth', 2, 'fontsize', 12, 'fontweight', 'bold', 'ydir', 'rev', ...
    'ylim', [1 size(PSD_in,1)], 'xlim', [3 200], 'ytick', linspace(1, size(PSD_in,1), nele), 'yticklabel', labels)

ylabel(c1, '% Diff. from Array Mean')

end