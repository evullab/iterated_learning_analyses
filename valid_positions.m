function is_valid=valid_positions(positions,task_params)
% make sure dots are in bound and don't overlap

env_rad=task_params.envRad;
dot_size=task_params.dotSize;

in_bound=~(sum(sqrt(sum(positions.^2,2))>(env_rad-dot_size))>0);
not_collide=~(sum(pdist(positions)<(dot_size))>0);

is_valid=in_bound && not_collide;


