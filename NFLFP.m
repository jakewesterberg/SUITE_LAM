function dat_out = NFLFP(dat_in, y, varargin)

r2hd            = 1;
spc             = mean(diff(y));

varStrInd = find(cellfun(@ischar,varargin));
for iv = 1:length(varStrInd)
    switch varargin{varStrInd(iv)}
        case {'r2hd'}
            r2hd = varargin{varStrInd(iv)+1};
    end
end

ch_vec = 2:size(dat_in,1)-1;
dat_out = nan(size(dat_in), numel(r2hd));

for dk = 1 : size(csd_trial,1)

    dat_out(dk, :) = ...
        nansum(dat_in(2:end-1,:) ./ ...
        repmat((sqrt((abs(ch_vec-dk).*spc).^2 + ...
        (r2hd .* spc)^2)'), [1, size(dat_in,2)]));

end

dat_out = dat_out ./ 1000;

end