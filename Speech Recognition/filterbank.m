%{
    Function    : filterbank
    Input       : Magnitude spectrum, number of channels
    Output      : rectangular filterbank output
    Description : Linear rectangular filterbank is appllied to the
    magnitude spectrum of the signal
%
function fbank = filterbank(magSpec, num_channel)
    num_samples = floor(length(magSpec)/num_channel);
    total_cnt = 1;
    for fb_num = 1:num_channel
        fbank(fb_num) = sum(magSpec(total_cnt:total_cnt+num_samples-1));
        total_cnt = total_cnt+num_samples;
    end
end
%}

%{
    Function    : filterbank
    Input       : Magnitude spectrum, number of channels
    Output      : mel scale filterbank output
    Description : Mel scale filterbank is appllied to the magnitude spectrum of the signal
%}
function fbank = filterbank(shortTimeMag, num_channel)
    mel_filter = melscale_filter(320, num_channel);
    %fbank = shortTimeMag'*mel_filter';
    fbank = mel_filter*shortTimeMag;
end

%{
    Function    : filterbank
    Input       : Magnitude spectrum, number of channels
    Output      : mel scale filterbank output
    Description : Mel scale filterbank is generated for the 320 samples
%}
function mel_filter = melscale_filter(len_mag_spec, num_channel)
	fs=16000;
	maxf = fs/2;                                    % The maximal frequency used
	maxmelf = 2595*log10(1+maxf/700);               % The maximal Mel-frequency -value  
	edgemelfs = (0:(num_channel+1))/(num_channel+1) * maxmelf;  % All triangle-filter edge Mel-frequency -values
	edgefrqs = 700*(10.^(edgemelfs/2595)-1);        % All triangle-filter edge frequencies ( in normal frequency scale )
	edgeDFTbins = round(edgefrqs/maxf*(len_mag_spec/2));    % All triangle-filter edge DFTbins customized to magSpec
	edgeDFTbins(1) = 1;                             % Just correcting the first bin not to be 0.

	if edgeDFTbins(2) == 0
		error('Can not create so many filters for this Ndft!')
	end

	mel_filter = zeros(num_channel,len_mag_spec/2);                 % Reserving memory for the filterbank. Each row of 'fbank'
													% corresponds to one triangle-filter.
	for n=1:num_channel
		l = edgeDFTbins(n);                         % start index for the lower edge
		c = edgeDFTbins(n+1);                       % center index for the triangle
		h = edgeDFTbins(n+2);                       % end index for the higher edge

		NbinsUpSlope = c-l;                         % Number of DFT-points in lower edge
		NbinsDownSlope = h-c;                       % Number of DFT-ponts in higher edge

		mel_filter(n,l:c) = (0:NbinsUpSlope)/NbinsUpSlope;        % Create the lower (frequency) slope  (going up) ...
		mel_filter(n,c:h) = (NbinsDownSlope:-1:0)/NbinsDownSlope; % Create the higher (frequency) slope (going down) ...
	end                                                         %  .. of filter number n.
end
