function rec_im = extend_denoise(denoiser, noise_im, ori_im, sigma_hat)


noise_im_extend = self_extend_transform(noise_im,ori_im, 0);
rec_im_extend = cell(size(noise_im_extend));
for i =1:8
    [img_h,img_w]=size(noise_im_extend{i});
    denoi=@(noisy,sigma_hat) denoise(noisy,sigma_hat,img_h, img_w,denoiser);
    rec_im_extend{i} = reshape(double(denoi(noise_im_extend{i},sigma_hat)),[img_h,img_w]);
    
end

rec_im = self_extend_transform(rec_im_extend, ori_im, 1);

rec_im = rec_im(:);

end