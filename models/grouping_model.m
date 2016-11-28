function all_data=grouping_model(fname,data,exp_params,task_params,hyper_params,num_samps)
% Run grouping model on all data
fname=strcat(fname,'_fits');
if ~exist(fname)
   mkdir(fname) 
end

all_data=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);

for id=1:exp_params.numDisp
    disp_fname=fullfile(fname,strcat('disp',num2str(id)));
    disp(strcat('disp',num2str(id)))
    if ~exist(disp_fname)
        mkdir(disp_fname)
    end
    for ic=1:exp_params.numChains
        chain_fname=fullfile(disp_fname,strcat('chain',num2str(ic)));
        
        if ~exist(chain_fname)
            mkdir(chain_fname)
        end
        for ii=1:exp_params.numIts
            
            its_fname=fullfile(chain_fname,strcat('iter',num2str(ii),'.mat'));
            if ~exist(its_fname)
%                 disp(strcat('disp',num2str(id)))
%                 disp(strcat('chain',num2str(ic)))
%                 disp(strcat('iter',num2str(ii)))
                to_sel=(data.Seed==id) & (data.Chain==ic) & (data.Iter==ii);
                xy=[data.x(to_sel) data.y(to_sel)];
                xy=xy+normrnd(0,.01,size(xy));
                
                hyper_params2=calc_priors(xy,hyper_params,task_params); % calculate means, covariances, etc.
                group_fits=infer_structure(xy,hyper_params2,num_samps);
                
                
                save(its_fname,'group_fits');
            else
                load(its_fname);
            end
            
            all_data{id,ic,ii}=get_mle_samps(group_fits,hyper_params);
%             if sum(strcmp({all_data{id,ic,ii}.groups.type},'clusterLine'))>0
%                 disp('line')
%             end
            clear group_fits
            fclose all;
        end
    end
    clc;
end

