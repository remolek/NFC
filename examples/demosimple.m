%% Simple example of using the rBeta method routines from
% https://github.com/remolek/NFC 
% to compute directed correlations, delays, etc
% rBeta "resting BOLD Event Triggered Average" as described first in 
% "Spontaneous BOLD event triggered averages for estimating functional
% connectivity at resting state"
% Tagliazucchi E, Balenzuela P, Fraiman D, Montoya P, Chialvo DR.  Neurosci Lett. (2011) 488(2):158-63.
% Revisited an extended in Cifre et al (https://www.frontiersin.org/articles/10.3389/fnins.2021.700171/full)

%% The example here uses time series from 90 regions from the AAL parcelation
% (file BOLD_90timeseries.mat) normalized to its standard deviation.
% The code computes the rbetas of signals stored in the rows of "matrix" rbetas of all regions against all others.
% The threshold for detection of an event is "thr" (in standard deviations units)
% The variable past determines the time units to which the rbeta window extends into the past
% The variable future determines the time units to which the rbeta window extends into the future
% For illustration some Pearson calculations are also computed
%%  
%% Comments and questions to dchialvo@gmail.com
%% -------------------------------------------------------------------------------
clc; clear; close all
 
load BOLD_90timeseries.mat  % A

corrPearson=corr(ts90'); % Pearson Correlation matrix 
[N P]=size(ts90);


%% Parameters defining an event %%
past=2; % number of TR before the BOLD peak defining the event
future=8;  % number of TR after the BOLD peak defining the event
thr=1.2;   % Threshold in SD units to define an event
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:N
   seed=ts90(i,:); % select one by one the ROI's to be sources (aka seeds)
    
   [events, events_seed,times_seed] = rbeta_events(ts90,seed, thr, past, future); % Array with events
   [corrs_mean(i,:), corrs] = rbeta_corrs(events,events_seed, -4, -2); % Array with the correlations between events
   [delays_mean(i,:), delays] = rbeta_delays(events,events_seed); % array with the delays bewteen events
   [delays_Pear(i,:)] = pear_delays(ts90,seed,past,future); % array withthe  delay computed using Pearson Correlation
   disp(strcat(num2str(i*100/size(ts90,1)),'%'));
end
asymm=corrs_mean-corrs_mean'; % Compute asymetry (a.k.a how directed is the FC)


%% Plot results
subplot(521)
%% Correlation from Pearson 
car2(1:N+1,1:N+1)=0;
car2(1:N,1:N)=corrPearson(1:N,1:N);
pcolor(car2);shading flat
%title('Pearson Corr')
colorbar
xlabel('ROI I')
ylabel('ROI J')

subplot(5,2,2);
histogram(reshape(corrPearson,N*N,1),40); title('Pearson Corr PDF')

%% Correlation from rBeta
 
subplot(523)
car(1:N+1,1:N+1)=0;
car(1:N,1:N)=corrs_mean(1:N,1:N);
pcolor(car);shading flat
colorbar
xlabel('ROI I')
ylabel('ROI J')
%title('rBeta Corr')

subplot(524);
histogram(reshape(corrs_mean,N*N,1),40);title('rBeta Corr PDF')
 
%% Asymmetry from rBeta

subplot(525)
car3(1:N+1,1:N+1)=0;
car3(1:N,1:N)=asymm(1:N,1:N);
 pcolor(car3);shading flat
colorbar
caxis([ -2.5 2.5]);
xlabel('ROI I')
ylabel('ROI J')
%title('Asymmetry')

subplot(526);
histogram(reshape(asymm,N*N,1),40);title('Asymmetry PDF (rBeta)')


%% Delay from Pearson

subplot(527) 
car4(1:N+1,1:N+1)=0;
car4(1:N,1:N)=delays_Pear(1:N,1:N);
 pcolor(car4);shading flat
colorbar
caxis([ -5 5]);
xlabel('ROI I')
ylabel('ROI J')
%title('Delay')

subplot(528);
histogram(reshape(delays_Pear,N*N,1),[-5:.25:5]);title('Delays - from Pearson Corr')


%% Delay from rBeta
subplot(529);

car5(1:N+1,1:N+1)=0;
 
car5(1:N,1:N)=delays_mean(1:N,1:N);
 pcolor(car5);shading flat
colorbar
xlabel('ROI I')
ylabel('ROI J')
caxis([ -5 5]);
subplot(5,2,10);
histogram(reshape(delays_mean,N*N,1),[-5:.25:5]);title('Delays - from rBeta')
