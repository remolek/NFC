# NFC
This is a repository of MATLAB codes accompanying the paper:
- Cifre I, Miller Flores MT, Penalba L, Ochab JK and Chialvo DR (2021) Revisiting Nonlinear Functional Brain Co-activations: Directed, Dynamic, and Delayed. Front. Neurosci. 15:700171. doi: 10.3389/fnins.2021.700171

See also how this meethod can be adapted to experiments in the task paradigm (not just resting-state):
- Ceglarek A, Ochab JK, Cifre I, Fafrowicz M, Sikora-Wachowicz B, Lewandowska K, Bohaterewicz B, Marek T and Chialvo DR (2021) Non-linear Functional Brain Co-activations in Short-Term Memory Distortion Tasks. Front. Neurosci. 15:778242. doi: 10.3389/fnins.2021.778242

Corresponding author: dchialvo@unsam.edu.ar (see also: http://www.chialvo.net)  
Repository manager: jeremi.ochab@uj.edu.pl (see also: http://cs.if.uj.edu.pl/jeremi)

## Functions and Options

General description:
- `rbeta_events` finds *events* in the source/seed signal (e.g., mean signal from a selected Region of Interest) and returns the segments of the source and target time series around the time of the event occurrence
- `rbeta_corrs` computes linear correlations between the source and target segments
- `rbeta_delays` computes delays between the estimated source event peak and the closest estimated peak in the target time series
- `pear_delays` computes delays by finding a shift maximising the covariance between the source and target time series

Usage and option:
`[events, events_seed, times_seed]=rbeta_events(matarr,seed, thr, past, future)`
`[corrs_mean, corrs]=rbeta_corrs(events,events_seed,pastD,futureD);`

% You can also use either:
% [delays_mean, delays]=rbeta_delays(events,events_seed,pastD,futureD);
%   which computes delays for each event 'delays' and for averaged events 'delays_mean'
% or only the average event delays (it skips computing individual events,
%   so it is much faster):
[delays_mean]=rbeta_delays(events,events_seed,pastD,futureD);
% By default, the script looks for the closest peaks, which can be set explicitly:
% [delays_mean]=rbeta_delays(events,events_seed,pastD,futureD,'closest');
% but it can also look for the largest peaks in the vicinity:
% [delays_mean]=rbeta_delays(events,events_seed,pastD,futureD,'largest');


## Compatibility

Checked for Matlab versions:
 - R2022a
 - TBA

For Python implementation, possibly faster, see https://github.com/gdbassett/rbeta.
