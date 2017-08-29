function n_transforms = parToMat( t_transforms )

    n = size(t_transforms, 1);
    n_transforms = cell(n, 1);
    for k = 1:n
        n_transforms{k} = [t_transforms(k, 3) t_transforms(k, 5) 0; 
                            t_transforms(k, 4) t_transforms(k, 6) 0; 
                            t_transforms(k, 1) t_transforms(k, 2) 1];
    end
end