% Lits of all protein complexes:
tags={'G3-G1';
'G3-T1';
'G3-TRY';
'G3-G3';
'G3-G1-T1';
'G3-T1-TRY';
'G1-G3-G3';
'T1-G3-G3';
'TRY-G3-G3';
'T1-G1-G3-G3';
'TRY-T1-G3-G3';
'G1-G3-G3-T1';
'G1-G3-G3-TRY';
'T1-G3-G3-TRY';
'G1-G3-G3-G1';
'T1-G3-G3-T1';
'TRY-G3-G3-TRY';
'G1-T1-G3-G3-G1';
'G1-T1-G3-G3-T1';
'G1-G3-G3-T1-TRY';
'G1-T1-G3-G3-TRY';
'T1-TRY-G3-G3-TRY';
'TRY-T1-G3-G3-T1';
'G1-T1-G3-G3-T1-G1';
'T1-TRY-G3-G3-TRY-T1';
'G1-T1-G3-G3-T1-TRY'};
% Keep track of inhibitor TRY in the complex:
hasTRY = [0;0;1;0;0;0;1;0;0;1;0;0;0;0;1;1;0;0;1;1;0;0;1;1;1;1;0;0;1;0;0;0;
    0;1;1;1;1;1;1;1;1;0;1;1;1];
%KD: GL3-GL1, GL3-TTG1, GL3-GL3, GL3-TRY, alpha
Kd = [0.5 1 0.5 1 0.4];
% Time span for integration
tspan = 0:1:10000;
% Initial conditions, only >0 for GL1, TTG1, TRY and GL3
x0 = zeros(1, 45);
x0(1:4) = [3.71 14.71 7 1]; % GL1 TTG1 TRY GL3
% ODE integration
[~,c]=ode15s(@crn_full,tspan,x0,[],Kd);
% Select steady state results
c = c(end,:);
% Print overview of complexes containing inhibitor
fprintf('Percentage of complexes+free protein that contain TRY: %.1f\n', sum(c(hasTRY==1))/sum(c)*100)
X=[c(5:10) c(11)+c(12) c(13)+c(14) c(15)+c(16) c(17)+c(18) c(19)+c(20) ....
c(21)+c(22) c(23)+c(24) c(25)+c(26) c(27:29) c(30)+c(31) c(32)+c(33) ...
c(34)+c(35) c(36)+c(37) c(38)+c(39) c(40)+c(41) c(42) c(43) c(44)+c(45)];

%%
% Plot results for all complexes in bar plot
figure;
X = (X./sum(X)).*100;
XhasTRY = [0 0 1 0 0 1 0 0 1 0 1 0 1 1 0 0 1 0 0 1 1 1 1 0 1 1];
fprintf('Percentage of complexes that contain TRY: %.1f\n', sum(X(XhasTRY==1))/sum(X)*100)
sum(X(XhasTRY==1))/sum(X(XhasTRY==0))
lineStyles = linspecer(numel(X),'sequential');
for b = 1 : numel(X)
    % Plot one single bar as a separate bar series.
    h(b) = barh(b, X(b), 'BarWidth', 0.9);
    hold on;
    % Apply the color to this bar series.
    set(h(b), 'FaceColor', lineStyles(b,:));
    % Place text atop the bar
    if X(b) < 10^-4
        barTopper = sprintf('0%%');
    elseif X(b) < 1
        barTopper = sprintf('<1%%');
    else
        barTopper = sprintf('%.1f%%', X(b));
    end
    text(X(b)+0.5, b+0.1, barTopper, 'FontSize', 10);
    
end
set(gca, 'YTick', 1:length(tags),'YTickLabel',tags);
set(gca,'XColor','none')
set(gca,'color','none')
box off


%%
% Code to generate the combinations given in the excel sheets
% conc = [0 0.25 1 2 3 4];
% combos = combvec(conc, conc, conc); combos = combos';
% mat=zeros(size(combos,1), numel(combos(1,:))+numel(tags)+1);
%%
% for i = 1:size(combos, 1)
%     x0 = zeros(1, 45);
%     x0(1:4) = [combos(i,:) 1];% G1 T1 TRY G3
%     [t,C]=ode15s(@crn_full,[0 10000],x0,[],Kd);
%     c = C(end,:);
%     X=[c(5:10) c(11)+c(12) c(13)+c(14) c(15)+c(16) c(17)+c(18) c(19)+c(20) ....
%     c(21)+c(22) c(23)+c(24) c(25)+c(26) c(27:29) c(30)+c(31) c(32)+c(33) ...
%     c(34)+c(35) c(36)+c(37) c(38)+c(39) c(40)+c(41) c(42) c(43) c(44)+c(45)];
%     X = (X./sum(X)).*100;
%     mat(i,:) = [combos(i,:) 1 X];
% end