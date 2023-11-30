function out = SUITE_LAM(LFP, varargin)

% Computes CSD, NFLFP, LFP correlation, and normalized power spectral
% density. Please remove bad channels before passing to this function.

% Outputs:
% out.CSD - matrix - channel x sample x trial --in nA/mm3 (top and bottom channel
% will be nans as they are lost during the calculation)
% out.CORRE - vector - 1 x time (time values relative to the event of interest
% that the LFP was aligned on)
% out.PSD -
% out.PSD_NORM - 
% out.PSD_F - 
% out.NFLFP -
%
% Inputs:
% LFP - matrix - channel x sample x trial --in mV (have all trials aligned to the
% event you are interested in, e.g.m visual array onset)
%
% (optional/varargin) 
% 'stream' - matrix - channel x sample (correlations and
% psd work better with the unaligned, continuous datastream, however it is
% not necessary to get good estimates)
% 'cndt' - value - conductance for Cx (default = 0.0004 [Logothetis et al.
% 2007, Neuron])
% 'spc' - value - interelectrode spacing in mm (default = 0.1)
% 'times' - vector - 1 x time (time values relative to the event of interest
% that the LFP was aligned on)
% 'win' - value - size of window for correlation computation (default =
% 512)

cndt        = 0.0004;
spc         = 0.1;
win         = 512;
do_plot     = false;
doCSD       = true;
methodCSD   = 'standard';

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'cndt'}
            cndt            = varargin{varStrInd(iv)+1};
        case {'spc'}
            spc             = varargin{varStrInd(iv)+1};
        case {'stream'}
            lfp_stream      = varargin{varStrInd(iv)+1};
        case {'times'}
            TV              = varargin{varStrInd(iv)+1};
        case {'tlim'}
            tlim            = varargin{varStrInd(iv)+1};
    end
end

if ~exist('TV', 'var');         TV = 1 : size(LFP, 2);          end
if ~exist('tlim', 'var');       tlim = [TV(1) TV(end)];         end

if doCSD
    switch methodCSD
        case 'standard'
            out.CSD = CSD(LFP, 'cndt', cndt, 'spc', spc);
            out.CSD_method = 'standard';
        case 'iCSD'
            out.CSD = iCSD(LFP, 'cndt', cndt, 'spc', spc);
            out.CSD_method = 'iCSD';
    end
end

if exist('lfp_stream', 'var')
    [out.PSD, out.PSD_NORM, out.PSD_F]                          = PSD(lfp_stream);
    out.CORRE                                                   = LFP_CORR(lfp_stream, win, true);
else
    [out.PSD, out.PSD_NORM, out.PSD_F]                          = PSD(LFP);
    out.CORRE                                                   = LFP_CORR(LFP, win, true);
end

if do_plot
   
    f_h = figure; hold on;
    
    ax1 = subplot(1, 3, 1);
    PLOT_CSD(nanmean(out.CSD(2:end-1, :, :),3), TV, tlim, f_h, ax1)
    
    ax2 = subplot(1, 3, 2);
    PLOT_PSD(out.PSD_NORM, out.PSD_F, f_h, ax2)
    
    ax3 = subplot(1, 3, 3);
    PLOT_CORR(out.CORRE, f_h, ax3)
    
end
end

