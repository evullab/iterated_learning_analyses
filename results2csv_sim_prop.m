function results2csv_sim_prop(file_prefix,results_fold,exp_params,res_ang_sim_prop,res_len_sim_prop)
% convert results to csv so compatible with r or python
% 9/5/2015-adapting to work with proportion based similarity results

exp_params.numIts=18; % similarity analyses use sliding window

% angle similarity
file_suffix='_ang_sim_prop.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_ang_sim_prop,exp_params,false);

% length similarity
file_suffix='_len_sim_prop.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_len_sim_prop,exp_params,false);

    function results2table(csv_fname,results,exp_params,continuous)
        
        all_disp=[];
        all_iter=[];
        all_val=[];
        if ~continuous
            all_cat=[];
        end
        for id =1:exp_params.numDisp
            
            for ii = 1:exp_params.numIts
                
                if continuous
                    % If each data point is continuous
                    all_disp=[all_disp; id];
                    all_iter=[all_iter; ii];
                    all_val=[all_val; results(id,ic,ii)];
                else
                    % If we have categories
                    for i_cat=1:size(results,3)
                        all_cat=[all_cat; i_cat];
                        all_disp=[all_disp; id];
                        all_iter=[all_iter; ii];
                        all_val=[all_val; results(id,ii,i_cat)];
                        
                    end
                    
                end
                
            end
        end
        
        if continuous
            csv_data=table(all_disp,all_iter,all_val);
            csv_data.Properties.VariableNames = {'disp','iter','value'};
            writetable(csv_data,csv_fname,'Delimiter',',');
        else
            csv_data=table(all_disp,all_iter,all_cat,all_val);
            csv_data.Properties.VariableNames = {'disp','iter','cat','value'};
            writetable(csv_data,csv_fname,'Delimiter',',');
        end
        
    end



end








