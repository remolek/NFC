function [corrs_mean, corrs] = rbeta(events,events_seed, pastD, futureD)
% INPUT
% events and events_seed as given by rbeta_events script
%
% OPTIONAL INPUT
% pastD, futureD:   negative numbers shortening rBeta events if adjustment
%                   is needed
% OUTPUT (optionally: one or both variables)
% corrs_mean:  array of correlations between seed mean rBeta and voxels'
%               mean rBeta, sized:
%               1 x (number of voxels)
% corrs:        array of correlations between seed rBeta events and voxels'
%               rBeta events, sized:
%               (number of voxels) x (number of seed events)

if ~exist('pastD','var')
      pastD = 0;
end
if ~exist('futureD','var')
      futureD = 0;
end

rbdim=[length(events), size(events_seed,1)];

if nargout >0
    events_seed=events_seed(:,1-pastD:end+futureD);     % shorten events, if needed
    seed_mean=mean(events_seed);
    corrs_mean=[]; corrs=[];
    for k = 1:rbdim(1)
        events_temp = events{k};
        events_temp=events_temp(:,1-pastD:end+futureD); % shorten events, if needed
        % Compute correlations of mean rBetas
        corr_temp=corrcoef(seed_mean,mean(events{k}(:,1-pastD:end+futureD)));
        corrs_mean=[corrs_mean corr_temp(1,2)];
        if nargout > 1
            % Compute correlations of event rBetas
            % 0 fast: 1.7
            for t=1:rbdim(2)
                corr_temp=corrcoef(events_seed(t,:),events_temp(t,:));
                corrs(k,t)=corr_temp(1,2);
            end
            % 1 slow: 2.0
            % corr_temp=arrayfun(@(x) corrcoef(events_seed(x,:),events_temp(x,:)),[1:length(locs)],'UniformOutput',false);
            % corrs{i}{k}=corr_temp(1,2);
            % 2 slow: 2.5
            % corrs{i}{k}=arrayfun(@(x) subindex2(corrcoef(events_seed(x,:),events_temp(x,:)),1,2),[1:length(locs)]);
            % 3 slow: 3.5
            % corrs{i}{k}=arrayfun(@(x) corr(events_seed(x,:)',events_temp(x,:)'),[1:length(locs)]);
        end
    end
end