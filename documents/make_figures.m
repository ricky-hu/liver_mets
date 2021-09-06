% making nice figures
both = load('rads_plus_dosimetric_fflp.csv_preds.mat').data;
rads = load('liver_plus_gtv.csv_preds.mat').data;
clin = load('clin_variables_dosimetric_fflp.csv_preds.mat').data;

%best case

figure(1)
set(gcf,'color','white')

subplot(3,2,1)
k = 2;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Radiomics + Dosimetric Data (Best Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off

subplot(3,2,2)
k = 3;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Radiomics + Dosimetric Data (Best Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off

subplot(3,2,3)
k = 2;
stairs(cell2mat(rads(k,3)),cell2mat(rads(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(rads(k,3)),cell2mat(rads(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Radiomics Data Only (Best Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off

subplot(3,2,4)
k = 1;
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(clin(k,3)),cell2mat(clin(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Radiomics Data Only (Worst Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off

subplot(3,2,5)
k = 2;
stairs(cell2mat(both(k,3)),cell2mat(both(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(both(k,3)),cell2mat(both(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Dosimetric Data Only (Best Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off

subplot(3,2,6)
k = 3;
stairs(cell2mat(both(k,3)),cell2mat(both(k,2)),'-r','LineWidth',1);
hold on
stairs(cell2mat(both(k,3)),cell2mat(both(k,1)),'-b','LineWidth',1);
title('Predicted and Actual Survival, Dosimetric Data Only (Worst Case)')
xlabel('Months');
ylabel('Survival Probability')
legend('Predicted Survival','Actual Survival')
ylim([0,1.1])
xlim([0,26])
xticks([0, 5, 10, 15, 20, 25])
yticks([0.0, 0.2, 0.4, 0.6, 0.8, 1.0])
hold off
