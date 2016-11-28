function new_samp=samp_struc(xy,prev_samp,hyper_params)
% creates new sample
    
    new_samp=generate_sample(xy,prev_samp,hyper_params);
    new_samp.llk=calc_llk(xy,new_samp,hyper_params);

end