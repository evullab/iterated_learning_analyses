function ind_output=distribution_response(targ,infer_struc,guess,mod_params,task_params)
% Acts as either pdf (if guess is set) or rand function (if guess is nan)

group=infer_struc.groups;
assign=infer_struc.assign;
num_dots=length(assign);

all_mean=mean(targ,1);
all_cov=cov(targ);
num_group=length(group);
num_line=sum(strcmp('clusterLine',{group.type}));
is_pdf=~isnan(guess);

%% calculate llk for objects from each group



if is_pdf
    is_valid=false; % if pdf, don't need to repeat and check for overlaps
    guess_map=Hungarian_2d(targ,guess);
    ind_output=nan(num_dots,1); % output llk of current guesses
else
    is_valid=true; % check if any violations
    ind_output=nan(size(targ));
end

for ig=1:num_group
    % get current group and items
    curr_group=group(ig);
    curr_id=curr_group.id;
    curr_targ=targ(assign==curr_id,:);
    if is_pdf
        curr_guess=guess_map(assign==curr_id,:);
    end

    if strcmp(curr_group.type,'clusterGaussianAnisotropic') || strcmp(curr_group.type,'clusterGaussianIsotropic')
        % If cluster, recall objects biased towards cluster

        [new_mu,new_cov]=integrate_cluster(targ,curr_id,group,assign,all_mean,all_cov,mod_params);
        if is_pdf
            llks=mvnpdf(curr_guess,new_mu,new_cov);
            ind_output(assign==curr_id)=-log(llks+eps());
        else

            temp=ind_output;
            noise=0; % sometimes objects get too close, prevent collisions
            is_valid=false;
            while ~is_valid

                new_pos=mvnrnd(new_mu,new_cov+noise);
                temp(assign==curr_id,:)=new_pos;
                is_valid=valid_positions(temp(~isnan(temp(:,1)),:),task_params);
                noise=noise+.01;
            end
            ind_output(assign==curr_id,:)=new_pos;
        end

    else

        if is_pdf
%             [new_mu,new_cov]=integrate_line(targ,curr_id,group,assign,mod_params);
%             llks=mvnpdf(curr_guess,new_mu,new_cov);
%             ind_output(assign==curr_id)=-log(llks+eps());

            [new_mu,new_sd]=integrate_line(targ,curr_id,group,assign,mod_params);
            llks=normpdf(curr_guess,new_mu,new_sd);
            ind_output(assign==curr_id)=sum(-log(llks+eps()),2);
        else
            % If rnd (generate new response randomly), remember lines and then remember objects biased
            % towards lines
            if num_line>1 && mod_params(1).line_hier
                % If we recall lines hierarchically AND there is more than
                % one line

                temp=ind_output;
                noise=0; % sometimes objects get too close, prevent collisions
                is_valid=false;
                while ~is_valid
                    
                    new_pos=recall_hierarchical_lines(targ,curr_id,group,assign,mod_params,noise);
                    % figure;hold on;plot_xy(targ);plot_xy(new_pos(:,1),new_pos(:,2),'ro')
                    temp(assign==curr_id,:)=new_pos;
                    is_valid=valid_positions(temp(~isnan(temp(:,1)),:),task_params);
                    noise=noise+.01;
                end
                ind_output(assign==curr_id,:)=new_pos;                

            else
                % If lines recalled independently/only one line

                temp=ind_output;
                noise=0; % sometimes objects get too close, prevent collisions
                is_valid=false;
                while ~is_valid
                    new_pos=recall_line(targ,curr_id,group,assign,mod_params,noise);
                    temp(assign==curr_id,:)=new_pos;
                    is_valid=valid_positions(temp(~isnan(temp(:,1)),:),task_params);
                    noise=noise+.01;
                end
                ind_output(assign==curr_id,:)=new_pos;

            end

        end



    end

end


end


