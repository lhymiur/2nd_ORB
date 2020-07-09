function [ denoised ] = denoise(noisy,sigma_hat,width,height,denoiser)

switch denoiser
    case '2ndORB'
        output = second_ORB(noisy, sigma_hat);
    otherwise
        error('Unrecognized Denoiser')
end
denoised=output(:);
end

