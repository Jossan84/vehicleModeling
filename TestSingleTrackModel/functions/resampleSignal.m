
%% resampleSignal
%--------------------------------------------------------------------------
% function [resampled_signal] = resampleSignal(signal,f)
% Inputs
%   - singal
%       * Object type: timeseries
%       * Description: Signal to be resampled
%   - f
%       * Type: double
%       * Description: Frecuency of resampling
%       * Unit: [Hz]
%
% Output
%   - resampled_signal
%       * Object type: timeseries
%       * Description: Resampled Signal
%--------------------------------------------------------------------------
% 2019/02/17

function [resampled_signal] = resampleSignal(signal,f)

    signal_mean = mean(signal.Time);      % Signal mean
    [m n] = size(signal.Time);            % Signal size  
    Ts = (signal_mean/m) * 2;             % Signal period
    
    Fs = 1/Ts;                            % Signal frecuency
    
    [p,q] = rat(f/Fs);                    % Get resampling factors
    
    Time = resample(signal.Time,p,q);     %Resample time to frequency f
    Data = resample(signal.Data,p,q);     %Resample data to frequency f
    
    resampled_signal = timeseries(Data,Time);   % Output
    
end

