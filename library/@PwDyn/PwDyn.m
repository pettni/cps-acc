classdef PwDyn
    % Class for piecewise linear dynamics
    
    properties (SetAccess=protected)
        num_region;
        domain = Polyhedron;
        reg_list = {};
        dyn_list = {};
        n;
        m;
        p;
        pm;
    end
    
    methods
        function pwd = PwDyn(domain, reg_list, dyn_list)
        % Constructor
            if size(reg_list) ~= size(dyn_list)
                error('Number of domains and number of dynamics must agree')
            end
            pwd.n = dyn_list{1}.n;
            pwd.m = dyn_list{1}.m;
            pwd.p = dyn_list{1}.p; 
            pwd.pm = dyn_list{1}.pm;   
            for i=1:size(dyn_list)
                if (dyn_list{i}.n ~= pwd.n) || (dyn_list{i}.m ~= pwd.m) || ...
                   (dyn_list{i}.p ~= pwd.p) || (dyn_list{i}.pm ~= pwd.pm)
                    error('Dyn objects do not have the same state/input/disturbance dimension')
                end
            end
            pwd.num_region = length(reg_list);
            pwd.domain = domain;
            pwd.reg_list = reg_list;
            pwd.dyn_list = dyn_list;
        end

        function dyn = get_region_dyn(pwd, point)
        % Get dynamics active in a specific point
            for i = 1:length(pwd.reg_list)
                if isInside(pwd.reg_list{i}, point)
                   dyn = pwd.dyn_list{i};
                   return;
                end
            end
            error(strcat('Point', mat2str(point), 'not inside any region'))
        end

        function plot_regions(pwd)
        % Plot the regions defining the state space
            hold on
            colors = hsv(pwd.num_region);
            for i = 1:length(pwd.reg_list)
                plot(pwd.reg_list{i}, 'color', colors(i,:))
            end
        end

        function plot_xdset(pwd, dims)
        % Plot the boundary of the x-d set
        %
        %  - dims: plot these dimensions of the X-D polytope
        %
            hold on
            colors = hsv(pwd.num_region);
            for i = 1:length(pwd.reg_list)
                AA = pwd.reg_list{i}.A;
                bb = pwd.reg_list{i}.b;
                intersect_poly = Polyhedron([AA zeros(size(AA,1), pwd.dyn_list{i}.p)], [bb]);
                ipoly = intersect(intersect_poly, pwd.dyn_list{i}.xd_poly());
                plot(projection(ipoly, dims), 'color', colors(i,:))
            end
        end

        function plot_xuset(pwd, dims)
        % Plot the boundary of the x-u set
        %
        %  - dims: plot these dimensions of the X-U polytope
        %
            hold on
            colors = hsv(pwd.num_region);
            for i = 1:length(pwd.reg_list)
                AA = pwd.reg_list{i}.A;
                bb = pwd.reg_list{i}.b;
                intersect_poly = Polyhedron([AA zeros(size(AA,1), pwd.dyn_list{i}.m)], [bb]);
                ipoly = intersect(intersect_poly, pwd.dyn_list{i}.XU_set);
                plot(projection(ipoly, dims), 'color', colors(i,:))
            end
        end 
    end    
end

