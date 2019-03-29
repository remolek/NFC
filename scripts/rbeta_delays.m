function [delays_mean, delays] = rbeta(events,events_seed,pastD,futureD,peakSetting)
% INPUT
% events and events_seed as given by rbeta_events script
%
% OPTIONAL INPUT
% pastD, futureD:   negative numbers shortening rBeta events if adjustment
%                   is needed
% OUTPUT (optionally: one or both variables)
% delays_mean:  array of delays between peak of seed mean rBeta and voxels'
%               mean rBeta peak, sized:
%               1 x (number of voxels)
% delays:       cell array, sized: (number of voxels)
%               containing array of delays, sized:

if ~exist('pastD','var')
      pastD = 0;
end
if ~exist('futureD','var')
      futureD = 0;
end
if ~exist('peakSetting','var')
      peakSetting = 'closest';
end
if strcmp(peakSetting,'closest')
elseif   strcmp(peakSetting,'largest')
else
	display('Wrong peak setting. It can take values "closest" or "largest". Setting changed to "closest".');
	peakSetting='closest';
end


rbdim=[length(events), size(events_seed,1)];

if nargout >0
    % Compute delays for mean rbetas
    % for seed
    if size(events_seed,1)==1
        events_temp=events_seed;
    else
        events_temp=mean(events_seed);
    end
    events_temp=events_temp(1-pastD:end+futureD);   % shorten events, if needed
    [pks,peakloc]=findpeaks(events_temp);
    if length(pks)==0
        peakloc=find(events_temp==max(events_temp));
        if peakloc>=length(events_temp)
            peakloc=peakloc-1;
        elseif peakloc==1
            peakloc=2;
        end
    else
        peakloc=peakloc(pks==max(pks));
    end         % find the highest peak
    peakloc=peakloc-1:peakloc+1;            % take 3 points
    params=polyfit(peakloc,events_temp(peakloc),2); % fit a parabola
    delay_seed=-params(2)/(2*params(1));    % find location of the parabola's peak
    % and for voxels
    delays_mean=[];
    %par
    for k = 1:rbdim(1)
        if size(events{k},1)==1
            events_temp=events{k};
        else
            events_temp=mean(events{k});
        end
        events_temp=events_temp(1-pastD:end+futureD);
        [pks,peakloc]=findpeaks(events_temp);
        if length(pks)==0
            peakloc=find(events_temp==max(events_temp));
            if peakloc>=length(events_temp)
                peakloc=peakloc-1;
            elseif peakloc==1
                peakloc=2;
            end
        else
			if strcmp(peakSetting,'closest')
			%			find the peak closest  to the seed peak
				peakloc=peakloc(find(abs(peakloc-delay_seed)==min(abs(peakloc-delay_seed))));
			elseif   strcmp(peakSetting,'largest')
			%			find the highest peak
				peakloc=peakloc(pks==max(pks));
			end

        end
        peakloc=peakloc-1:peakloc+1;
        params=polyfit(peakloc,events_temp(peakloc),2);
        delays_mean=[delays_mean, -params(2)/(2*params(1))-delay_seed];
    end
    
end

if nargout >1
    
    % % Compute event-wise delays
    % for seed
    delay_seed=[];
    %par
    for i = 1:rbdim(2)
        events_temp=events_seed(i,1-pastD:end+futureD);
        [pks,peakloc]=findpeaks(events_temp);
        if length(pks)==0
            peakloc=find(events_temp==max(events_temp));
            if peakloc>=length(events_temp)
                peakloc=peakloc-1;
            elseif peakloc==1
                peakloc=2;
            end
        else
            peakloc=peakloc(pks==max(pks));
        end
        peakloc=peakloc-1:peakloc+1;
        params=polyfit(peakloc,events_temp(peakloc),2);
        delay_seed=[delay_seed, -params(2)/(2*params(1))];
    end
    % and for voxels
    %par
    for k = 1:rbdim(1)
        events_temp=events{k};
        events_temp=events_temp(:,1-pastD:end+futureD);
        delay_temp=[];
        for i = 1:rbdim(2)
            [pks,peakloc]=findpeaks(events_temp(i,:));
            if length(pks)==0
                peakloc=find(events_temp(i,:)==max(events_temp(i,:)));
                if peakloc>=size(events_temp,2)
                    peakloc=peakloc-1;
                elseif peakloc==1
                    peakloc=2;
                end
            else
                peakloc=peakloc(pks==max(pks));
            end
            peakloc=peakloc-1:peakloc+1;
            params=polyfit(peakloc,events_temp(i,peakloc),2);
            delay_temp=[delay_temp, -params(2)/(2*params(1))];
        end
        delays{k}=delay_temp-delay_seed;
    end
end