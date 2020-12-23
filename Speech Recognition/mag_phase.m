%{
    Function    : mag_phase
    Input       : 20 msec hamming signal
    Output      : magnitude and phase spectra
    Description : Time domain signal is converted into frequency domain,
    magnitude and phase spectra of the signal is also calculated
%}
function [shortTimeMag, shortTimePhase] = mag_phase(hamming_sig_block)
    ft_sig = fft(hamming_sig_block);
    shortTimeMag = abs(ft_sig(1:length(hamming_sig_block)/2));
    shortTimePhase = angle(ft_sig);
end