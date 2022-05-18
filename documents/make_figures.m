% making nice figures
both = load('rads_plus_dosimetric_fflp.csv_preds.mat').data;
rads = load('liver_plus_gtv.csv_preds.mat').data;
clin = load('clin_variables_dosimetric_fflp.csv_preds.mat').data;


    
%best K-Fold

figure(1)
set(gcf,'color','white')

subplot(3,2,1)
k = 2;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-.b','LineWidth',1);
title('Radiomics + Treatment Data (Best K-Fold)')
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])

yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(clin(k,1));
times = cell2mat(clin(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])
hold off

subplot(3,2,2)
k = 3;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-.b','LineWidth',1);
title('Radiomics + Treatment Data (Worst K-Fold)')
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(clin(k,1));
times = cell2mat(clin(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])
hold off

subplot(3,2,3)
k = 2;
stairs(cell2mat(rads(k,3)),cell2mat(rads(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(rads(k,3)),cell2mat(rads(k,1)),'-.b','LineWidth',1);
title('Radiomics Data Only (Best K-Fold)')

ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(rads(k,1));
times = cell2mat(rads(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])

hold off

subplot(3,2,4)
k = 1;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-.b','LineWidth',1);
title('Radiomics Data Only (Worst K-Fold)')

ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])

yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(clin(k,1));
times = cell2mat(clin(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])
hold off

subplot(3,2,5)
k = 2;
stairs(cell2mat(both(k,3)),cell2mat(both(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(both(k,3)),cell2mat(both(k,1)),'-.b','LineWidth',1);
title('Treatment Data Only (Best K-Fold)')

ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(both(k,1));
times = cell2mat(both(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])

hold off

subplot(3,2,6)
k = 3;
stairs(cell2mat(both(k,3)),cell2mat(both(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(both(k,3)),cell2mat(both(k,1)),'-.b','LineWidth',1);
title('Treatment Data Only (Worst K-Fold)')

ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])

%displaying at risk population
%making # at risk tables
months = [0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24];
actuals = cell2mat(both(k,1));
times = cell2mat(both(k,3));
allatrisk = floor(actuals.*21);
dummy = size(months);
numMonths = dummy(2);
%finding index closest to months ticker
for i = 1:numMonths
    month = months(i);
    idxs = find(times(1,:) <= month);
    idx = idxs(end);
    atrisk(i) = allatrisk(idx);
end
labelMat = [months; atrisk]; 
tickLabels = compose('%5d\\newline%5d',labelMat(:).'); 
set(gca,'XTick', 0:numel(tickLabels), 'XTickLabel', tickLabels, 'TickDir', 'out') % [5]
xticks([0, 2, 4, 6, 8, 10, 12,14,16,18,20,22,24])

hold off

sgtitle('Predicted and Actual Survival (Freedom From Local Progression)') 
