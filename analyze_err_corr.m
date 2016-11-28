function [same_err_corr,diff_err_corr]=analyze_err_corr(data,all_mle,exp_params)
disp('Analyzing error correlations of groups')

same_err_corr=nan(exp_params.numDisp,exp_params.numChains,(exp_params.numIts-1));
diff_err_corr=nan(exp_params.numDisp,exp_params.numChains,(exp_params.numIts-1));

for id=1:exp_params.numDisp

    for ic=1:exp_params.numChains

        for ii=1:(exp_params.numIts-1)
            curr_data=data(data.Seed==id & data.Chain==ic & data.Iter==ii,:);
            curr_xy=[curr_data.x,curr_data.y];
            curr_assign=all_mle{id,ic,ii}.assign;
            curr_assign_mat=repmat(curr_assign,1,15)==repmat(curr_assign,1,15)';
            same_group=curr_assign_mat;
            same_group(logical(eye(15)))=0;
            
            diff_group=~curr_assign_mat;
            
            next_data=data(data.Seed==id & data.Chain==ic & data.Iter==(ii+1),:);
            next_xy=[next_data.x,next_data.y];
            
            map_xy=Hungarian_2d(curr_xy,next_xy);
            
            dist_mat=findCrossCorr(curr_xy,map_xy);
            same_err_corr(id,ic,ii)=mean(dist_mat(same_group));
            diff_err_corr(id,ic,ii)=mean(dist_mat(diff_group));
            
        end
    end
end