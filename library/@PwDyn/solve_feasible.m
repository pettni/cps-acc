function [ S ] = solve_feasible(pwd, X, N)
    % SOLVE_FEASIBLE: Find a backward-time reachable set.
    % ======================================================
    %
    % SYNTAX
    % ------
    %   X0 = solve_feasible(dyn, X, N)
    %
    % DESCRIPTION
    % -----------
	% 	Finds the set S such that from anywhere in S, 
	% 	X can be reached in N time steps using the
	% 	dynamics dyn.
    %
    % 	If dyn contains disturbance, this is taken into
    %	account by assuming the worst case disturbance.
    % 
    % INPUT
    % -----
    %   pwdyn   Piece-wise Linear System dynamics
    %           Class: PwDyn
    %   X   	Final set
    %           Class: Polyhedron or PolyUnion
    %   N 	    Number of time steps
    %           Default: 1
    %
    % REMARK: Usage with N larger than 1 will force state to remain,
    %         in the same region in intermediate steps
	
    S = PolyUnion;
    for i=1:pwd.num_region
        new_poly = intersect1(pwd.reg_list{i}, pwd.dyn_list{i}.solve_feasible(X, N));
        S = add1(S, new_poly);
    end
end