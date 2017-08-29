function n_transforms = optimizeAffineTransforms( t_transforms, im_size )

run('~/cvx/cvx_setup.m');

n = size(t_transforms, 1);
center_x = round(im_size(2) / 2);
center_y = round(im_size(1) / 2);
crop_w = round(im_size(2) * 0.8);
crop_h = round(im_size(1) * 0.8);
crop_x = round(center_x - crop_w / 2);
crop_y = round(center_y - crop_h / 2);
crop_points = [crop_x crop_y;
                crop_x + crop_w crop_y;
                crop_x crop_y + crop_h;
                crop_x + crop_w crop_y + crop_h];


w1 = 10; w2 = 1; w3 = 100;
c1 = [1 1 100 100 100 100]';
c2 = c1;
c3 = c1;

U = zeros(6, 6);
U(3, 1) = 1; U(6, 4) = 1;
U(4, 2) = 1; U(5, 3) = 1;
U(3, 5) = 1; U(6, 5) = -1;
U(4, 6) = 1; U(5, 6) = 1;
lb = [0.9 -0.1 -0.1 0.9 -0.1 -0.05];
ub = [1.1 0.1 0.1 1.1 0.1 0.05];

cvx_begin
variable p(n, 6);
variable e1(n, 6);
variable e2(n, 6);
variable e3(n, 6);

minimize(sum(w1*e1*c1 + w2*e2*c2 + w3*e3*c3))

subject to 

    % Smoothness
    for k = 1:n - 3 
        B_t = [p(k, 3) p(k, 5) 0; p(k, 4) p(k, 6) 0; p(k, 1) p(k, 2) 1];
        B_t1 = [p(k + 1, 3) p(k + 1, 5) 0; p(k + 1, 4) p(k + 1, 6) 0; p(k + 1, 1) p(k + 1, 2) 1];
        B_t2 = [p(k + 2, 3) p(k + 2, 5) 0; p(k + 2, 4) p(k + 2, 6) 0; p(k + 2, 1) p(k + 2, 2) 1];
        B_t3 = [p(k + 3, 3) p(k + 3, 5) 0; p(k + 3, 4) p(k + 3, 6) 0; p(k + 3, 1) p(k + 3, 2) 1];
        
        res_t = t_transforms{k + 1} * B_t1 - B_t; 
        res_t1 = t_transforms{k + 2} * B_t2 - B_t1; 
        res_t2 = t_transforms{k + 3} * B_t3 - B_t2; 

        res_t = [res_t(3, 1) res_t(3, 2) res_t(1, 1) res_t(2, 1) res_t(1, 2) res_t(2, 2)];
        res_t1 = [res_t1(3, 1) res_t1(3, 2) res_t1(1, 1) res_t1(2, 1) res_t1(1, 2) res_t1(2, 2)];
        res_t2 = [res_t2(3, 1) res_t2(3, 2) res_t2(1, 1) res_t2(2, 1) res_t2(1, 2) res_t2(2, 2)];


        -e1(k, :) <= res_t <= e1(k, :);
        -e2(k, :) <= res_t1 - res_t <= e2(k, :);
        -e3(k, :) <= res_t2 - 2*res_t1 + res_t <= e3(k, :);
    end

    for k = n-3:n
        p(k, 6) == p(n, 6);
    end

    for k=1:n
        e1(k, :) >= 0;
        e2(k, :) >= 0;
        e3(k, :) >= 0; 
    end

    % Proximity constraints
    for k = 1:n 
        lb <= p(k, :) * U <= ub;
    end

    % Inclusion contraints
    for i = 1:4
        for k = 1:n
            0 <= [1 0 crop_points(i, 1) crop_points(i, 2) 0 0] * p(k, :)' <= im_size(2);
            0 <= [0 1 0 0 crop_points(i, 1) crop_points(i, 2)] * p(k, :)' <= im_size(1);
        end
    end

cvx_end

n_transforms = parToMat(p);
end