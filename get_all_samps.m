function all_samps=get_all_samps(fname,seed,chain,iter)
% gets all samples from specified display

all_samps=cell(length(seed),length(chain),length(iter));

for is=1:length(seed)
    for ic=1:length(chain)
        for ii=1:length(iter)
            address=fullfile(strcat(fname,'_fits'),strcat('disp',num2str(seed(is))),strcat('chain',num2str(chain(ic))),strcat('iter',num2str(iter(ii)),'.mat'));
            load(address)
            all_samps{is,ic,ii}=group_fits;
            fclose all;
        end
    end
end

end