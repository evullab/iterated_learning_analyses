function quant_sim=partition2quantile(all_sim,cell_sim,exp_params)
num_qs=5;
prcs=prctile(all_sim,linspace(0,100,num_qs));

quant_sim=cell(size(cell_sim));
for id=1:exp_params.numDisp
    for ic=1:exp_params.numChains
        for ii=1:exp_params.numIts
            curr_sim=cell_sim{id,ic,ii};
            if ~isempty(curr_sim)
                quant_in=sum(repmat(curr_sim',1,num_qs-1)>repmat(prcs(1:end-1),length(curr_sim),1),2);
                quant_sim{id,ic,ii}=quant_in;
            end
        end
    end
end
end