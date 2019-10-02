%Making signal 48kHz (for PEAQ)
fs1 = fs;
fs = 48000;
[P,Q] = rat(fs/fs1);
sig_48 = resample(sig,P,Q);