function all_score=compare_grouping(subj_groups,all_samps)

all_score=nan(length(subj_groups),1);

for i=1:length(subj_groups)
    curr_subj_group=subj_groups{i};
    curr_mod_samps=[all_samps{i}.assign]';
    curr_mat=zeros(15,15);
    for s =size(curr_mod_samps,1)/2:size(curr_mod_samps,1)
        
        curr_mat=curr_mat+double(repmat(curr_mod_samps(s,:)',1,15)==repmat(curr_mod_samps(s,:),15,1));
    end
    curr_prop=(curr_mat+1)/(curr_mat(1,1)+1);
%     all_score(i)=sum(curr_subj_group(:).*(log10(curr_subj_group(:)./curr_prop(:))));
    off_diag=~logical(eye(15));
%     all_score(i)=abs(sum(curr_subj_group(off_diag).*(log10(curr_subj_group(off_diag)./curr_prop(off_diag)))));
%     all_score(i)=abs(sum((log10(curr_subj_group(off_diag)./curr_prop(off_diag)))));
    all_score(i)=sum(abs(curr_subj_group(off_diag)-curr_prop(off_diag)));
end

end