randn('state',0);
rand('state',0);

addpath('./NoiseLevelEstimate1');

Test_image_dir = '../../Test_Images/set8/set8/';
Out_image_dir = '../../Test_Images/set8/noise/';

create_noise_image();

dir_name = dir(fullfile(Out_image_dir,'*.mat'));

for i = 1:length(dir_name)
    load(fullfile(Out_image_dir, dir_name(i).name));
    sigma_hat(i)=SigEstmate_SigCNN(data);
    [sigma_hat2(i),~] = NoiseLevel(data);
    fprintf('%s, %s\n',num2str(sigma_hat(i)),num2str(sigma_hat2(i)))
    
end


function [] = create_noise_image()
sigma_test = [0,20, 50, 80,100,120];
Test_image_dir = '../../Test_Images/set8/set8/';
Out_image_dir = '../../Test_Images/set8/noise/';
dir_name = dir(fullfile(Test_image_dir,'*.tif'));
for k=1:length(dir_name)
    
    Image_name = fullfile(Test_image_dir, dir_name(k).name);
    ori_im = double(imread(Image_name));
    
    for i=1:5
        
        sigma = sigma_test(i);
        data = gaussian_noise(ori_im, 0, sigma);
        fp = [fullfile(Out_image_dir, dir_name(k).name(1:end-4)),'_sigma_',num2str(sigma),'.mat'];
        save(fp, 'data');
        [sigma_hat,~] = NoiseLevel(data);
        fprintf('%f\n',sigma_hat)
        
    end
end
end




