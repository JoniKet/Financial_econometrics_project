clc
clear all


%% importing the data


% importing BTC data
[numbers1,date1,useless1] = xlsread('Coinbase_BTCUSD_1h.csv');
dates_BTC = datetime(date1(2:end,1),'InputFormat','yyyy-MM-dd hh-a');
logReturnsBTC = numbers1(1:end,3);
 
% importing DOGEcoin data
[numbers2,date2,useless2] = xlsread('MuokattuDOGETOBTCANDUSD1h.csv');
dates_DOGE = datetime(date2(2:end-1,1),'InputFormat','yyyy-MM-dd hh-a');
logReturnsDOGE = numbers2(1:end-1,6);

% importing ETH data

[numbers3,date3,useless3] = xlsread('MuokattuETHUSD1h.csv');
dates_ETH = datetime(date3(2:end,1),'InputFormat','yyyy-MM-dd hh-a');
logReturnsETH = numbers3(1:end,7);


%% checking that the data has all the hours during that time period

d1BTC = datetime(dates_BTC(1),'InputFormat','yyyy-MM-dd hh-a');
d2BTC = datetime(dates_BTC(end),'InputFormat','yyyy-MM-dd hh-a');
periodBTC = d1BTC:hours(1):d2BTC;

d1DOGE = datetime(dates_DOGE(1),'InputFormat','yyyy-MM-dd hh-a');
d2DOGE = datetime(dates_DOGE(end),'InputFormat','yyyy-MM-dd hh-a');
periodDOGE = d1DOGE:hours(1):d2DOGE;

d1ETH = datetime(dates_ETH(1),'InputFormat','yyyy-MM-dd hh-a');
d2ETH = datetime(dates_ETH(end),'InputFormat','yyyy-MM-dd hh-a');
periodETH = d1ETH:hours(1):d2ETH;

if length(periodBTC) == length(dates_BTC) && length(periodBTC) == length(logReturnsBTC)
    fprintf('All hours/days are included in source data for the trading pair BTCUSD \n');
    fprintf('First datetime %s  \n',d1BTC);
    fprintf('Last datetime %s  \n',d2BTC);
end

if length(periodDOGE) == length(dates_DOGE)&& length(periodDOGE) == length(logReturnsDOGE)
    fprintf('All hours/days are included in source data for the trading pair DOGEUSD \n');
    fprintf('First datetime %s  \n',d1DOGE);
    fprintf('Last datetime %s  \n',d2DOGE);
end

if length(periodETH) == length(dates_ETH)&& length(periodETH) == length(logReturnsETH)
    fprintf('All hours/days are included in source data for the trading pair ETHUSD \n');
    fprintf('First datetime %s  \n',d1ETH);
    fprintf('Last datetime %s  \n',d2ETH);
end

% checking for nan values

if sum(isnan(logReturnsBTC)) == 0 && sum(isnan(logReturnsDOGE))== 0 && sum(isnan(logReturnsETH)) == 0
    fprintf('no NaN values')
end



%% plotting the logarithmic returns
figure
subplot(311)
plot(dates_BTC,logReturnsBTC), axis tight;
title('Hourly Logarithmic returns for BTC in USD');
subplot(312)
plot(dates_DOGE,logReturnsDOGE), axis tight
title('Hourly Logarithmic returns for DOGE in USD');
subplot(313)
plot(dates_ETH,logReturnsETH), axis tight
title('Hourly Logarithmic returns for ETH in USD');

%% plotting histograms of the returns

figure
hold on
histogram(logReturnsBTC,30,'normalization','probability','FaceAlpha',0.9)
histogram(logReturnsDOGE,30,'normalization','probability','FaceAlpha',0.4)
histogram(logReturnsETH, 30, 'normalization','probability','FaceAlpha',0.4)
legend({'Bitcoin','Dogecoin','Ethereum'});
xlabel('Hourly log return')
ylabel('Probability')
title('Histograms of hourly logarithmic  returns');
hold off

%% normality test for the logaritmic returns

[h,p,jbstat,critval] = jbtest(logReturnsBTC,0.05) %% not normally distributed
[h,p,jbstat,critval] = jbtest(logReturnsDOGE,0.05)
[h,p,jbstat,critval] = jbtest(logReturnsETH,0.05)

%% making a matrix of the dummy variables for every hour

matrix = zeros(length(logReturnsBTC),24); matrix2 = zeros(length(logReturnsDOGE),24); matrix3 = zeros(length(logReturnsETH),24);


for i = 1:24:length(logReturnsBTC)
    for j = 0:1:23
        if i+j <= length(logReturnsBTC)
            matrix(i+j,j+1) = 1;
        end
    end
end

for i = 1:24:length(logReturnsDOGE)
    for j = 0:1:23
        if i+j <= length(logReturnsDOGE)
            matrix2(i+j,j+1) = 1;
        end
    end
end

for i = 1:24:length(logReturnsETH)
    for j = 0:1:23
        if i+j <= length(logReturnsETH)
            matrix3(i+j,j+1) = 1;
        end
    end
end

parameterNames = {'DailyLogReturns','From_0_to_1','From_1_to_2','From_2_to_3','From_3_to_4','From_4_to_5','From_5_to_6','From_6_to_7','From_7_to_8','From_8_to_9','From_9_to_10','From_10_to_11','From_11_to_12','From_12_to_13','From_13_to_14','From_14_to_15','From_15_to_16','From_16_to_17','From_17_to_18','From_18_to_19','From_19_to_20','From_20_to_21','From_21_to_22','From_22_to_23','From_23_to_24'};
tbl1 = table(logReturnsBTC,matrix(:,1),matrix(:,2),matrix(:,3),matrix(:,4),matrix(:,5),matrix(:,6),matrix(:,7),matrix(:,8),matrix(:,9),matrix(:,10),matrix(:,11),matrix(:,12),matrix(:,13),matrix(:,14),matrix(:,15),matrix(:,16),matrix(:,17),matrix(:,18),matrix(:,19),matrix(:,20),matrix(:,21),matrix(:,22),matrix(:,23),matrix(:,24),'VariableNames',parameterNames);

tbl2 = table(logReturnsDOGE,matrix2(:,1),matrix2(:,2),matrix2(:,3),matrix2(:,4),matrix2(:,5),matrix2(:,6),matrix2(:,7),matrix2(:,8),matrix2(:,9),matrix2(:,10),matrix2(:,11),matrix2(:,12),matrix2(:,13),matrix2(:,14),matrix2(:,15),matrix2(:,16),matrix2(:,17),matrix2(:,18),matrix2(:,19),matrix2(:,20),matrix2(:,21),matrix2(:,22),matrix2(:,23),matrix2(:,24),'VariableNames',parameterNames);

tbl3 = table(logReturnsETH,matrix3(:,1),matrix3(:,2),matrix3(:,3),matrix3(:,4),matrix3(:,5),matrix3(:,6),matrix3(:,7),matrix3(:,8),matrix3(:,9),matrix3(:,10),matrix3(:,11),matrix3(:,12),matrix3(:,13),matrix3(:,14),matrix3(:,15),matrix3(:,16),matrix3(:,17),matrix3(:,18),matrix3(:,19),matrix3(:,20),matrix3(:,21),matrix3(:,22),matrix3(:,23),matrix3(:,24),'VariableNames',parameterNames);


%% making the models WITHOUT CONSTANT

Model_BTC_hourly = fitlm(tbl1,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23+From_23_to_24 -1')
Model_DOGE_hourly = fitlm(tbl2,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23+From_23_to_24 -1')
Model_ETH_hourly = fitlm(tbl3,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23+From_23_to_24 -1')


%% making the models WITH CONSTANT

Model_BTC_hourly2 = fitlm(tbl1,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23')
Model_DOGE_hourly2 = fitlm(tbl2,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23')
Model_ETH_hourly2 = fitlm(tbl3,'DailyLogReturns ~ From_0_to_1 + From_1_to_2 + From_2_to_3+From_3_to_4+From_4_to_5+From_5_to_6+From_6_to_7+From_7_to_8+From_8_to_9+From_9_to_10+From_10_to_11+From_11_to_12+From_12_to_13+From_13_to_14+From_14_to_15+From_15_to_16+From_16_to_17+From_17_to_18+From_18_to_19+From_19_to_20+From_20_to_21+From_21_to_22+From_22_to_23')


%% Parameter stability testing

[h,pValue,stat,cValue] = chowtest(matrix,logReturnsBTC,[1500],'Intercept',false,'Display','summary');
[h,pValue,stat,cValue] = chowtest(matrix,logReturnsDOGE,[1500],'Intercept',false,'Display','summary');
[h,pValue,stat,cValue] = chowtest(matrix,logReturnsETH,[1500],'Intercept',false,'Display','summary');


%% f-test

%% illustrating all of the 24h models in one pic (Creating the data for R)


figure
hold on
plot(1:1:24,Model_BTC_hourly.Coefficients(:,1).Estimate)
plot(1:1:24,Model_DOGE_hourly.Coefficients(:,1).Estimate)
plot(1:1:24,Model_ETH_hourly.Coefficients(:,1).Estimate)

toPlotBTC = abs(Model_BTC_hourly.Coefficients.Estimate).*(1-Model_BTC_hourly.Coefficients.pValue).*10000;

toPlotDOGE = abs(Model_DOGE_hourly.Coefficients.Estimate).*(1-Model_DOGE_hourly.Coefficients.pValue).*10000;

toPlotETH = abs(Model_ETH_hourly.Coefficients.Estimate).*(1-Model_ETH_hourly.Coefficients.pValue).*10000;

















% EOF