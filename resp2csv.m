function csv_data=resp2csv(resp,exp_params)
% converts model's response to table so we can run grouping_model on it

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
            curr_dots=resp{id,ic,ii};
            for io = 1:exp_params.numDots
                
                seedCol=[seedCol id];
                chainCol=[chainCol ic];
                itsCol=[itsCol ii];
                dotsCol=[dotsCol io];
                xCol=[xCol curr_dots(io,1)];
                yCol=[yCol curr_dots(io,2)];
                
                count=count+1;
            end
        end
    end
end

csv_data=table(seedCol',chainCol',itsCol',dotsCol',xCol',yCol');
csv_data.Properties.VariableNames = {'Seed','Chain','Iter','dots','x','y'};