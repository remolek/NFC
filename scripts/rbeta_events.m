function [events, events_seed, times_seed] = rbeta(matarr,seed, thr, past, future)
% % INPUT
% seed:     a mean seed ROI BOLD signal, sized: 1 x T
% matarr:   array with all voxel signals, sized: (number of voxels) x T
% % OUTPUT
% events_seed:  an array of seed events (from STANDARDISED seeds), sized:
%               (number of seed events) x (past+future+1)
% events:       cell array, sized: number of voxels 
%               each events{voxel} contains array of target events (from NON-STANDARDISED matarr), sized:
%               (number of seed events) x (past+future+1)

seed = zscore(seed);
rbdim = size(matarr);
BOLD=heaviside(seed-thr);
% find threshold crossings
[pks,locs]=findpeaks(BOLD);
% take only windows that do not stick outside of time series
locs=locs(locs+future<=rbdim(2)+1 & locs-past>1)-1;
if nargout>2
    times_seed=locs;
end
times_temp=[];
for t = locs
    times_temp = [times_temp, t-past:t+future];
end
% store seed events
events_seed=reshape(seed(times_temp),[past+future+1,length(locs)])';

% for each voxel
for k = 1:rbdim(1)
    % store target events
    events_temp=reshape(matarr(k,times_temp),[past+future+1,length(locs)])';
    events{k} = events_temp;
end
