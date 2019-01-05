%% DayOfTheWeekTest
clc
clear all
close all

%% importing the data

[numbers_BTC,date1,~]=xlsread('BTC_USD_DAILY.csv');
[numbers_DOGE,date2,~]=xlsread('DOGE_USD_DAILY.csv');
[numbers_GRC,date3,~]=xlsread('GRC_USD_DAILY.csv');

logChanges_BTC = numbers_BTC([2:end-1],4); % 2 because first parameter = Monday.
logChanges_DOGE = numbers_DOGE([2:end-1],4);
logChanges_GRC = numbers_GRC([2:end-1],4);



%% Checking that the data has all the days during that time period
% BTC

dates_BTC = datetime(date1(2:end,1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');

d2_BTC = datetime(dates_BTC(1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');
d1_BTC = datetime(dates_BTC(end),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC')+1; % moving to Monday.
NumDays_BTC = daysact(d1_BTC,d2_BTC);

% comparing the number of days to number of columns in returns.
if (size(logChanges_BTC,1) == NumDays_BTC)
    fprintf('All days are included in source data for BTC. \n');
    fprintf('First datetime %s.\n',d1_BTC); 
    fprintf('Last datetime %s.\n\n',d2_BTC);  
end
    
% DOGE
dates_DOGE = datetime(date2(2:end,1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');

d2_DOGE = datetime(dates_DOGE(1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');
d1_DOGE = datetime(dates_DOGE(end),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC')+1;
NumDays_DOGE = daysact(d1_DOGE,d2_DOGE);

% comparing the number of days to number of columns in returns.
if (size(logChanges_DOGE,1) == NumDays_DOGE)
    fprintf('All days are included in source data for DOGE. \n');
    fprintf('First datetime %s.\n',d1_DOGE); 
    fprintf('Last datetime %s.\n\n',d2_DOGE);  
end

% GRC

dates_GRC = datetime(date2(2:end,1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');

d2_GRC = datetime(dates_GRC(1),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC');
d1_GRC = datetime(dates_GRC(end),'InputFormat','yyyy-MM-dd HH:mm:ss Z','TimeZone','UTC')+1;
NumDays_GRC = daysact(d1_GRC,d2_GRC);

% comparing the number of days to number of columns in returns.
if (size(logChanges_GRC,1) == NumDays_GRC)
    fprintf('All days are included in source data for GRC. \n');
    fprintf('First datetime %s.\n',d1_GRC); 
    fprintf('Last datetime %s.\n\n',d2_GRC);  
end

% checking for NaN -elements
if sum(isnan(logChanges_BTC)) == 0 && sum(isnan(logChanges_DOGE))== 0 && sum(isnan(logChanges_GRC)) == 0
    fprintf('No NaN -values.\n')
end

%% Plotting the logaritmic returns

figure(1)
subplot(311)
plot(dates_BTC(end-1:-1:2),logChanges_BTC), axis tight;
title('Daily Logarithmic returns for BTC in USD');
subplot(312)
plot(dates_DOGE(end-1:-1:2),logChanges_DOGE), axis tight;
title('Daily Logarithmic returns for DOGE in USD');
subplot(313)
plot(dates_GRC(end-1:-1:2),logChanges_GRC), axis tight;
title('Daily Logarithmic returns for GRC in USD');


%% making a matrix of the dummy variables for every day

matrix = zeros(length(logChanges_BTC),7);

for i = 1:7:length(logChanges_BTC)
    for j = 0:1:6
        if i+j <= length(logChanges_BTC)
            matrix(i+j,j+1) = 1;
        end
    end
end

parameterNames = {'DailyLogReturns','Monday','Tuesday','Wedneday','Thursday','Friday','Saturday','Sunday'};

table1 = table(logChanges_BTC,matrix(:,1),matrix(:,2),matrix(:,3),matrix(:,4),matrix(:,5),matrix(:,6),matrix(:,7),'VariableNames',parameterNames);
table2 = table(logChanges_DOGE,matrix(:,1),matrix(:,2),matrix(:,3),matrix(:,4),matrix(:,5),matrix(:,6),matrix(:,7),'VariableNames',parameterNames);
table3 = table(logChanges_GRC,matrix(:,1),matrix(:,2),matrix(:,3),matrix(:,4),matrix(:,5),matrix(:,6),matrix(:,7),'VariableNames',parameterNames);
%% making the models

mdl_BTC = fitlm(table1,'DailyLogReturns ~ Monday+Tuesday+Wedneday+Thursday+Friday+Saturday+Sunday -1')

mdl_DOGE = fitlm(table2,'DailyLogReturns ~ Monday+Tuesday+Wedneday+Thursday+Friday+Saturday+Sunday -1')

mdl_GRC = fitlm(table3,'DailyLogReturns ~ Monday+Tuesday+Wedneday+Thursday+Friday+Saturday+Sunday -1')

%% Parameter stability testing


[h,pValue,stat,cValue] = chowtest(matrix,logChanges_BTC,[675],'Intercept',false,'Display','summary');
[h,pValue,stat,cValue] = chowtest(matrix,logChanges_DOGE,[675],'Intercept',false,'Display','summary');
[h,pValue,stat,cValue] = chowtest(matrix,logChanges_GRC,[675],'Intercept',false,'Display','summary');

%% multicollinnearity test

inv(matrix'*matrix);


%% normal distribution of the residuals

% figure(4)
% btcResiduals = mdl_BTC.Residuals.Raw;
% plot(btcResiduals)
% [h,p,jbstat,critval] = jbtest(btcResiduals,0.05)
% 
% figure(5)
% dogeResiduals = mdl_DOGE.Residuals.Raw;
% plot(dogeResiduals)
% [h,p,jbstat,critval] = jbtest(dogeResiduals,0.05)
% 
% figure(6)
% grcResiduals = mdl_GRC.Residuals.Raw;
% plot(grcResiduals)
% [h,p,jbstat,critval] = jbtest(grcResiduals,0.05)


%% Statistics

% STDEV

% Sdev_BTC = std(logChanges_BTC)
% Sdev_DOGE = std(logChanges_DOGE)
% Sdev_GRC = std(logChanges_GRC)
% 
% % MEAN, MAX, MIN
% 
% max_BTC = max(logChanges_BTC)
% max_DOGE = max(logChanges_DOGE)
% max_GRC = max(logChanges_GRC)
%    
% min_BTC = min(logChanges_BTC)
% min_DOGE = min(logChanges_DOGE)
% min_GRC = min(logChanges_GRC)
% 
% mean_BTC = mean(logChanges_BTC)
% mean_DOGE = mean(logChanges_DOGE)
% mean_GRC = mean(logChanges_GRC)

%% Daily log returns

% BTC
logChanges_Monday_BTC = logChanges_BTC(1:7:end);
logChanges_Tuesday_BTC = logChanges_BTC(2:7:end);
logChanges_Wednesday_BTC = logChanges_BTC(3:7:end);
logChanges_Thursday_BTC = logChanges_BTC(4:7:end);
logChanges_Friday_BTC = logChanges_BTC(5:7:end);
logChanges_Saturday_BTC = logChanges_BTC(6:7:end);
logChanges_Sunday_BTC = logChanges_BTC(7:7:end);

% means of daily log returns
Means_BTC = [mean(logChanges_Monday_BTC) 
mean(logChanges_Tuesday_BTC) 
mean(logChanges_Wednesday_BTC) 
mean(logChanges_Thursday_BTC)
mean(logChanges_Friday_BTC) 
mean(logChanges_Saturday_BTC)
mean(logChanges_Sunday_BTC)];



% DOGE
logChanges_Monday_DOGE = logChanges_DOGE(1:7:end);
logChanges_Tuesday_DOGE = logChanges_DOGE(2:7:end);
logChanges_Wednesday_DOGE = logChanges_DOGE(3:7:end);
logChanges_Thursday_DOGE = logChanges_DOGE(4:7:end);
logChanges_Friday_DOGE = logChanges_DOGE(5:7:end);
logChanges_Saturday_DOGE = logChanges_DOGE(6:7:end);
logChanges_Sunday_DOGE = logChanges_DOGE(7:7:end);

% means of daily log returns
Means_DOGE = [mean(logChanges_Monday_DOGE) 
mean(logChanges_Tuesday_DOGE) 
mean(logChanges_Wednesday_DOGE) 
mean(logChanges_Thursday_DOGE)
mean(logChanges_Friday_DOGE) 
mean(logChanges_Saturday_DOGE)
mean(logChanges_Sunday_DOGE)];


% GRC
logChanges_Monday_GRC = logChanges_GRC(1:7:end);
logChanges_Tuesday_GRC = logChanges_GRC(2:7:end);
logChanges_Wednesday_GRC = logChanges_GRC(3:7:end);
logChanges_Thursday_GRC = logChanges_GRC(4:7:end);
logChanges_Friday_GRC = logChanges_GRC(5:7:end);
logChanges_Saturday_GRC = logChanges_GRC(6:7:end);
logChanges_Sunday_GRC = logChanges_GRC(7:7:end);

% means of daily log returns
Means_GRC = [mean(logChanges_Monday_GRC) 
mean(logChanges_Tuesday_GRC) 
mean(logChanges_Wednesday_GRC) 
mean(logChanges_Thursday_GRC)
mean(logChanges_Friday_GRC) 
mean(logChanges_Saturday_GRC)
mean(logChanges_Sunday_GRC)];
