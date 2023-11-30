%% iCSD. Pettersen model  (units are in [m] not [mm] in pettersen model, CSD_cs is in [nA/m3] )

function [zs, iCSD] = iCSD(Ve, varargin)
% FUNCTION ICSDSPLINE_PETTERSEN calculate the CSD using spline iCSD method
% 
% method by Pettersen et al. 2006.
% written by Beatriz Herrera 2019.
% updated by Jake Westerberg 2022.
%
% Inputs:
%   - Ve: local field potentials [Nchannels x Ntimepts] in volts
%   - el_pos: electrodes position relative to the pia matter [meters]
%   - diam: diameter of the cylinder considered to calculate the CSD [meters]
%   - cond: conductance in S/m. If length(cond)==1 cond_top=cond= grey
%   matter conductance. otherwise [cond, cond_top] = [grey matter 
%   conductance, conductance at the top of the cylinder]
%   - gauss_sigma: Gaussian filter standard deviation in meters for the
%   spatial smoothing. 
%
% Outputs:
%   - zs: [mm] depth relative to the pia matter at which the CSD was
%   calculated
%   - iCSD: [nA/mm3] CSD metrix with rows 
%
%% Parameters

Ne = size(Ve, 1); % number of electrodes in the shank
a = 0.1; % [mm] position of the first electrode
elec_spacing = 0.1; % [mm] electrode spacing 
ze = a:elec_spacing:((Ne-1)*elec_spacing + a); % electrode positions with respect to the pia surface % WARNING: position of the first electrode must be different from zero
el_pos = ze*1e-3;  % mm to m
cond = 0.33; %[S/m] gray matter conductance | NOTE: if length(cond)==1, the function iCSDspline_Pettersen() considers con_top = cond (conductance at the top of the cylinder or above the pia matter)
gauss_sigma = 0.1e-3;   %[m] Gaussian filter std
diam = 3e-3; % [m] cylinder diameter

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'diam'}
            diam = varargin{varStrInd(iv)+1};
        case {'el_pos'}
            el_pos = varargin{varStrInd(iv)+1};
        case {'cond'}
            cond = varargin{varStrInd(iv)+1};
        case {'gauss_sigma'}
            gauss_sigma = varargin{varStrInd(iv)+1};
    end
end

if length(cond) > 1
    cond_1 = cond(1); % [S/m] grey matter conductance
    cond_top = cond(2); %[S/m] conductance at the top (cylinder)
else
    cond_1 = cond; % [S/m] grey matter conductance
    cond_top = cond; %[S/m] conductance at the top (cylinder)
end
filter_range = 5*gauss_sigma; % numeric filter must be finite in extent

%% solve Pettersen model
Fcs = F_cubic_spline(el_pos,diam,cond_1,cond_top);

for ii = 1 : size(Ve, 3)
    [zst,CSD_cs] = make_cubic_splines(el_pos,Ve,Fcs);
    [zst,CSD_cs] = gaussian_filtering(zst,CSD_cs,gauss_sigma,filter_range); % current source density and electrodes' position
    iCSD(:,:,ii) = CSD_cs; % [nA/mm3] current source density
    zs(:,:,ii) = zst*1e3;
end

end

