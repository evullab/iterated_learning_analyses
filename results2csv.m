function results2csv(file_prefix,results_fold,exp_params,res_k,res_dispersion,res_lines,res_ang_sim,res_len_sim)
% convert results to csv so compatible with r or python

% K
file_suffix='_num_k.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_k,exp_params,true);

% dispersion
file_suffix='_dispersion.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_dispersion,exp_params,true);

% line proportion
file_suffix='_line_proportion.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_lines,exp_params,true);

exp_params.numIts=18; % similarity analyses use sliding window

% angle similarity
file_suffix='_ang_sim.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_ang_sim,exp_params,true);

% length similarity
file_suffix='_len_sim.csv';
results_file=fullfile(results_fold,strcat(file_prefix,file_suffix));
results2table(results_file,res_len_sim,exp_params,true);

    function results2table(csv_fname,results,exp_params,continuous)
        
        all_disp=[];
        all_chain=[];
        all_iter=[];
        all_val=[];
        if ~continuous
            all_cat=[];
        end
        for id =1:exp_params.numDisp
            for ic = 1:exp_params.numChains
                for ii = 1:exp_params.numIts
                    
                    if continuous
                        % If each data point is continuous
                        all_disp=[all_disp; id];
                        all_chain=[all_chain; ic];
                        all_iter=[all_iter; ii];
                        all_val=[all_val; results(id,ic,ii)];
                    else
                        % If we have categories
                        for i_cat=1:size(results,4)
                            all_cat=[all_cat; i_cat];
                            all_disp=[all_disp; id];
                            all_chain=[all_chain; ic];
                            all_iter=[all_iter; ii];
                            all_val=[all_val; results(id,ic,ii,i_cat)];
                            
                        end
                        
                    end
                end
            end
        end
        
        if continuous
            csv_data=table(all_disp,all_chain,all_iter,all_val);
            csv_data.Properties.VariableNames = {'disp','chain','iter','value'};
            writetable(csv_data,csv_fname,'Delimiter',',');
        else
            csv_data=table(all_disp,all_chain,all_iter,all_cat,all_val);
            csv_data.Properties.VariableNames = {'disp','chain','iter','cat','value'};
            writetable(csv_data,csv_fname,'Delimiter',',');
        end
        
    end



end








