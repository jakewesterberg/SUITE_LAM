function PLOT_CSD(csd_in, time_vec, tlim, f, ax)

hold off;
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);
hold on;

tej = flipud(colormap('jet'));

csd_in = [csd_in(1,:) ; csd_in ; csd_in(end,:)];
nele = size(csd_in,1);
csd_in = SMOOTH_2D(csd_in);

limi = nanmax(nanmax(abs(csd_in)));

imagesc(time_vec, 1:size(csd_in,1), csd_in);

xlabel('Time from event (ms)');
ylabel('Lower<-Cx (Depth)->Upper');
title('CSD');

for i = 1 : nele
    labels{i} = num2str(i);
end

set(gca,'linewidth', 2, 'fontsize', 12, 'fontweight', 'bold', 'xlim', tlim, 'ydir', 'rev', ...
    'ylim', [1 size(csd_in,1)], 'ytick', linspace(1, size(csd_in,1), nele), 'yticklabel', labels)

caxis([-limi limi]);
colormap(tej);
c1 = colorbar;
ylabel(c1, 'nA/mm3)')

end