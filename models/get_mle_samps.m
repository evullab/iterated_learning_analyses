function mle_samp=get_mle_samps(curr_samps,hyper_params)

all_llk=nan(length(curr_samps),1);
for is = 1:length(curr_samps)
    curr_samp=curr_samps(is);
    curr_llk=[curr_samp.llk];
    
    curr_prior=nan(size(curr_llk));
    curr_assign=[curr_samp.assign];
    curr_group=[curr_samp.groups];
    for ig = 1:length(curr_group)
        curr_prior(curr_assign==curr_group(ig).id)=log10(curr_group(ig).group_prior);
    end
    all_llk(is)=sum(curr_llk+curr_prior);
end
[m,ind]=max(all_llk);

mle_samp=curr_samps(ind);

end





