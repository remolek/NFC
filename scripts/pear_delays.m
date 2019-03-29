function [delays_Pear] = pear_delay(matarr,seed,past,future,peakSetting)
% % INPUT
% seed:     a mean seed ROI BOLD signal, sized: 1 x T
% matarr:   array with all voxel signals, sized: (number of voxels) x T
% 
% OPTIONAL INPUT
% past, future:   negative numbers shortening rBeta events if adjustment
%                   is needed
% OUTPUT (optionally: one or both variables)
% delays_Pear:  array of delays between seed and voxels, sized:
%               1 x (number of voxels)

if ~exist('past','var')
      past = 6;
end
if ~exist('futureD','var')
      future = 6;
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

subindex=@(A,i,j) A(i,j); % allows indexing function output
dim=size(matarr,1);

res_cov=[];
delays_Pear=zeros(dim,1);
for j=1:dim
    for d=-past:future
        temp1=matarr(j,past+1+d:end-future+d);
        temp2=seed(past+1:end-future);
        res_cov(past+1+d)=subindex(cov(temp1,temp2),1,2);
    end
    
    [pks,peakloc]=findpeaks(res_cov);
    if isempty(peakloc)
        if res_cov(1)>res_cov(end); peakloc=1; else peakloc=past+future+1; end
    elseif strcmp(peakSetting,'closest')
        %			find the peak closest  to the seed peak
        peakloc=peakloc(find(abs(peakloc-past-1)==min(abs(peakloc-past-1))));
    elseif   strcmp(peakSetting,'largest')
        %			find the highest peak
        peakloc=peakloc(pks==max(pks));
    end
    if peakloc==past+future+1 | peakloc==1
        delays_Pear(j)=peakloc-past-1;
    elseif length(peakloc)>1 % there were peaks at the same distance from 0
        ties=[];
        for p=peakloc
            p=p-1:p+1;            % take 3 points
            params=polyfit(p,res_cov(p),2); % fit a parabola
            ties=[ties -params(2)/(2*params(1))-past-1];
        end
        % let the better resolution decide
        delays_Pear(j)=ties(find(abs(ties-past-1)==min(abs(ties-past-1))));
    else
        peakloc=peakloc-1:peakloc+1;            % take 3 points
        params=polyfit(peakloc,res_cov(peakloc),2); % fit a parabola
        delays_Pear(j)=-params(2)/(2*params(1))-past-1;    % find location of the parabola's peak
    end
end

   