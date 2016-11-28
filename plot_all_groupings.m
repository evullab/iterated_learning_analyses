function plot_all_groupings(fname,data,all_mle,exp_params)

fname=strcat(fname,'_plots');
disp(strcat('Plotting groupings for ',fname ))

if ~exist(fname)
    mkdir(fname)
end

for id=1:exp_params.numDisp
    disp(strcat('Display:',num2str(id)))
    
    dname=fullfile(fname,strcat('disp',num2str(id)));
    if ~exist(dname)
        mkdir(dname)
    end
    for ic=1:exp_params.numChains
        cname=fullfile(dname,strcat('chain',num2str(ic)));
        if ~exist(cname)
            mkdir(cname)
        end
        
        for ii=1:exp_params.numIts
            iname=fullfile(cname,strcat('iter',num2str(ii),'.png'));
            if ~exist(iname)
                to_sel=(data.Seed==id) & (data.Chain==ic) & (data.Iter==ii);
                xy=[data.x(to_sel) data.y(to_sel)];
                
                plot_grouping(iname,xy,all_mle{id,ic,ii});
                close;
            end

        end
    end
end


