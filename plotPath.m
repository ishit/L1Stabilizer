function [] = plotPath( t_transforms, n_transforms )
%%plotPath Summary
%  Plots original camera path and optimized camera path

    num_frames = size(t_transforms, 1) + 1;
    orig_a = zeros(num_frames - 1, 1);
    C_t = cell(num_frames - 1, 1);
    x = [0 0 1];
    for k = 1:num_frames-1
        x = x * t_transforms{k};
        C_t{k} = x;
        orig_a(k) = x(2); 
    end

    new_a = zeros(num_frames - 1, 1);
    for k = 1:num_frames-1
        y = C_t{k} * n_transforms{k};
        new_a(k) = y(2); 
    end

    figure;
    plot(orig_a, '-r'); hold on;
    plot(new_a, '-g'); hold off;
    title('Motion in y');
    legend('Original Path','Optimized Path');

    orig_a = zeros(num_frames - 1, 1);
    C_t = cell(num_frames - 1, 1);
    x = [0 0 1];
    for k = 1:num_frames-1
        x = x * t_transforms{k};
        C_t{k} = x;
        orig_a(k) = x(1); 
    end

    new_a = zeros(num_frames - 1, 1);
    for k = 1:num_frames-1
        y = C_t{k} * n_transforms{k};
        new_a(k) = y(1); 
    end

    figure;
    plot(orig_a, '-r'); hold on;
    plot(new_a, '-g'); hold off;
    title('Motion in x');
    legend('Original Path','Optimized Path');
end