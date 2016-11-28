function [all_ang_sim,all_len_sim,ang_sim,len_sim]=get_similarity_lines(all_mle,exp_params)

% Keep track of all line differences so we can organize into quartiles
all_ang_sim=[];
all_len_sim=[];

% Cell array since iterations contain different numbers of lines
ang_sim=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
len_sim=cell(exp_params.numDisp,exp_params.numChains,exp_params.numIts);
for id=1:exp_params.numDisp

    for ic=1:exp_params.numChains

        for ii=1:exp_params.numIts
            is_line=strcmp({all_mle{id,ic,ii}.groups.type},'clusterLine');
            num_lines=sum(is_line);
            if num_lines>=2
                curr_lines=all_mle{id,ic,ii}.groups(is_line);
                ang_s=calc_line_ang_sim(curr_lines);
                len_s=calc_line_len_sim(curr_lines);
                
                ang_sim{id,ic,ii}=ang_s;
                len_sim{id,ic,ii}=len_s;
                all_ang_sim=[all_ang_sim,ang_s];
                all_len_sim=[all_len_sim,len_s];
            end
            
        end
    end
end

    function ang_sim=calc_line_ang_sim(curr_lines)
        ang_sim=[];
        for i =1:length(curr_lines)
            for j =1:length(curr_lines)
                if i~=j
                    line_i=normAng(curr_lines(i).ang);
                    line_j=normAng(curr_lines(j).ang);
                    temp_sim=abs(line_i-line_j);
                    while temp_sim>(pi/2)
                        temp_sim=temp_sim-(pi/2);
                    end
                    ang_sim=[ang_sim, rad2deg(temp_sim)];
                end
            end
        end
    end

    function len_sim=calc_line_len_sim(curr_lines)
        len_sim=[];
        for i =1:length(curr_lines)
            for j =1:length(curr_lines)
                if i~=j
                    line_i=curr_lines(i).len;
                    line_j=curr_lines(j).len;
                    temp_sim=abs(line_i-line_j);
                    len_sim=[len_sim,temp_sim];
                end
            end
        end
    end

    function ang=normAng(slope)
            % Calculate angle relative to east
            angTemp=atan(slope);
            if slope<0
                % If left side, add pi to account for angle being relative to
                % west
                ang=pi+angTemp;
            elseif slope>0
                if angTemp<0
                    ang=(2*pi)+angTemp;
                else
                    ang=angTemp;
                end
            else
                ang=angTemp;
            end
        end
    end