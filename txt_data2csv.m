function csv_data=txt_data2csv(data_fname,exp_id,exp_params)
txt_fname=fullfile('data',strcat(data_fname,'.txt'));
csv_fname=fullfile('data',strcat(data_fname,'.csv'));

if ~exist(csv_fname)

    datafile=fopen(txt_fname);
    data =textscan(datafile,'%s %d %d %d %s %s %s %s %s %d %s %s %s', 'delimiter','$');
    data{2}=data{2}+1; % align with matlab
    data{3}=data{3}+1;
    data{4}=data{4}+1;
    
    [targX, targY,subjs]=load_from_txt(data,exp_id,exp_params);
    
    %% convert to csv
    subjCol={};
    seedCol=[];
    chainCol=[];
    itsCol=[];
    dotsCol=[];
    xCol=[];
    yCol=[];
    count=1;
    for id =1:exp_params.numDisp
        for ic = 1:exp_params.numChains
            for ii = 1:exp_params.numIts
                for io = 1:exp_params.numDots
                    
                    if ii==1
                        subjCol{count}=strcat('base',num2str(id),'_',num2str(ic));
                    else
                        subjCol{count}=subjs{id,ic,ii-1};
                    end
                    
                    seedCol=[seedCol id];
                    chainCol=[chainCol ic];
                    itsCol=[itsCol ii];
                    dotsCol=[dotsCol io];
                    xCol=[xCol targX(id,ic,ii,io)];
                    yCol=[yCol targY(id,ic,ii,io)];
                    
                    count=count+1;
                end
            end
        end
    end
    
    csv_data=table(subjCol',seedCol',chainCol',itsCol',dotsCol',xCol',yCol');
    csv_data.Properties.VariableNames = {'Subject','Seed','Chain','Iter','dots','x','y'};
    writetable(csv_data,csv_fname,'Delimiter',',');
else
    csv_data=readtable(csv_fname);
end
    
    
