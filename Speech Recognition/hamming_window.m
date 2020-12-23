%{
    Function    : hamming_window
    Input       : 20 msec block
    Return      : 20 msec hamming signal
    Description : Given 20 msec block is multiplied with the hamming signal
    of same size
%}
function sig_with_hamming = hamming_window(sml_blk)
    ham_sig = hamming(length(sml_blk));                      % hamming window
    sig_with_hamming = sml_blk.*ham_sig;                     % applying hamming window
end
