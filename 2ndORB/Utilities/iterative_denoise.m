function rec_im = iterative_denoise(denoi, noise_im, sigma_hat)

itr = 20;
[h, w] = size(noise_im);
x = noise_im;
for i=1:itr
    
    v = reshape(double(denoi(x,sigma_hat)),[h, w]);
    x = 0.81.*x+0.1.*noise_im+0.09*v;
    sigma_hat=SigEstmate_SigCNN(x);
    
end

rec_im = x;

end