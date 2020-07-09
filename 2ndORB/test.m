warning off
addpath('../matconvnet-1.0-beta25/matlab/mex');
addpath('../matconvnet-1.0-beta25/matlab');
addpath('../matconvnet-1.0-beta25/matlab/simplenn');
addpath(genpath('Trained_Weights'));
addpath('Utilities');
run('../matconvnet-1.0-beta25/matlab/vl_setupnn.m');
randn('state',1);
rand('state',1);

denoise_name_all = {'2ndORB'};
Test_image_dir = '../test_images/Set12';
PSNR_sum = 0;
for k=1:12
    dir_name = [dir(fullfile(Test_image_dir,'*.png'))];
    Image_name = fullfile(Test_image_dir, dir_name(k).name);
    ori_im = double(imread(Image_name));
    [img_h, img_w, ~] = size(ori_im);
    sigma = 25;
    noise_im = gaussian_noise(ori_im, 0, sigma);
    for j=[1]
        %% denoize_choice
        % 1: 2ndORB
        %%
        denoiser = denoise_name_all{j};
        denoi=@(noisy,sigma_hat) denoise(noisy,sigma_hat,img_h, img_w,denoiser);
        sigma_hat = sigma;
        tic
        rec_im = reshape(double(denoi(noise_im,sigma_hat)),[img_h, img_w]);
        toc;
        [sigma_hat,~] = NoiseLevel(rec_im);
        fprintf('Image:%d, Denoiser:%d, Sigma-noise:%f, Sigma-clean:%f, Psnr = %f\n', k, j, sigma, sigma_hat, csnr(rec_im, ori_im, 8,0, 0));
        PSNR_sum = PSNR_sum+csnr(rec_im, ori_im, 8,0, 0);        
    end
end
PSNR_sum = PSNR_sum/12

