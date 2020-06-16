function output=second_ORB(noisy, sigma_hat)
global global_time
if sigma_hat == 15
    name='2nORB_sigma15.mat';
elseif sigma_hat == 25
    name='2nORB_sigma25.mat';
elseif sigma_hat == 50
    name='2nORB_sigma50.mat';
end
useGPU = 1;
load(name);%loads net
patch_flag = 0;
if patch_flag == 1
    img_size = size(noisy);
    patch_size = [128, 128];
    step_size = [8,8];
    batch_size = 4;
    noisy = im2patch(noisy,patch_size,step_size);
    noisy1(:,:,1,:) = noisy;
    noisy = noisy1;
    input_list_index = 1:batch_size:size(noisy,4);
    
    if useGPU == 1
        
        noisy = single(noisy/(255/2)-1);
        noisy=real(noisy);
        input = gpuArray(noisy);
        net = vl_simplenn_move(net, 'gpu') ;
        tic
        for i = 1:length(input_list_index)
            input_list = (i-1)*batch_size+1:min((i-1)*batch_size +batch_size,size(noisy,4));
            res = vl_simplenn(net,input(:,:,:,input_list),[],[],'conserveMemory',true,'mode','test');
            output(:,:,:,input_list) = res(end).x;
        end
        global_time = global_time+toc;
        output = double(gather((output+1)*255/2));
    else
        
        noisy = noisy/(255/2)-1;
        input = noisy;
        res = simplenn_matlab(net, input);
        output = res(end).x;
        output = (output+1)*255/2;
        
    end
    output = squeeze(output);
    output = patch2im(output, img_size, patch_size, step_size);
else
    if useGPU == 1
        
        noisy = single(noisy/(255/2)-1);
        noisy=real(noisy);
        input = gpuArray(noisy);
        
        net = vl_simplenn_move(net, 'gpu') ;
        tic
        res = vl_simplenn(net,input,[],[],'conserveMemory',true,'mode','test');
        output = res(end).x;
        global_time = global_time+toc;
        output = double(gather((output+1)*255/2));
    else
        
        noisy = noisy/(255/2)-1;
        input = noisy;
        res = simplenn_matlab(net, input);
        output = res(end).x;
        output = (output+1)*255/2;
        
    end
end

end
