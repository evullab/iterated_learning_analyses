function [all_data,all_mod_targ]=run_cognitive_model(seeds,mod_params,exp_params,task_params,num_samps)
% Run grouping model on all data

cogmod_fold_name='cogmod_resp';
if ~exist(cogmod_fold_name)
    mkdir(cogmod_fold_name)
end

fname=fullfile(cogmod_fold_name,strcat(mod_params(1).resp_name,'_cogmod'));
if ~exist(fname)
    mkdir(fname)
end

all_data=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
all_mod_resp=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
all_mod_targ=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);

for id=1:exp_params.numDisp
    disp_fname=fullfile(fname,strcat('disp',num2str(id)));
    disp(strcat('disp',num2str(id)))
    if ~exist(disp_fname)
        mkdir(disp_fname)
    end
    for ic=1:exp_params.numChains
        disp(strcat('chain',num2str(ic)))
        chain_fname=fullfile(disp_fname,strcat('chain',num2str(ic)));
        
        if ~exist(chain_fname)
            mkdir(chain_fname)
        end
        for ii=1:exp_params.numIts
            
            
            its_fname=fullfile(chain_fname,strcat('iter',num2str(ii),'.mat'));
            
            if ~exist(its_fname)
                if ii==1
                    to_sel=(seeds.Seed==id) & (seeds.Chain==ic) & (seeds.Iter==ii);
                    xy=[seeds.x(to_sel) seeds.y(to_sel)];
                else
                    xy=all_mod_resp{id,ic,ii-1};
                end
                xy=xy+normrnd(0,.01,size(xy));
                mod_params2=calc_priors(xy,mod_params,task_params); % calculate means, covariances, etc.
                
                group_fits=infer_structure(xy,mod_params2,num_samps);
                mle_samp=get_mle_samps(group_fits,mod_params);
                
                line_id=strcmp('clusterLine',{mle_samp.groups.type});
                if sum(line_id)==1
                    disp(strcat(num2str(ii),'_line'))
                elseif sum(line_id)>1
                    disp(strcat(num2str(ii),'_many_lines'))
                end
                % Get new responses!

                mod_resp=distribution_response(xy,mle_samp,nan,mod_params2,task_params);
                %figure;hold on;plot(xy(:,1),xy(:,2),'ko');plot(mod_resp(:,1),mod_resp(:,2),'ro')
%                 save(its_fname,'group_fits','mle_samp','xy','mod_resp');
                
                % 11/21/2016 saving space
                save(its_fname,'mle_samp','xy','mod_resp');

            else
                load(its_fname);
            end
            
            all_data{id,ic,ii}=mle_samp;
            all_mod_resp{id,ic,ii}=mod_resp;
            all_mod_targ{id,ic,ii}=xy;

            clear group_fits
            fclose all;
        end
    end
%     clc;
end

