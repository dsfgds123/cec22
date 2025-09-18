% 果蝇位置初始化函数
function [X, Y] = initialization(pop, ub, lb, dim)
%input
%pop 种群数量
%ub 变量上边界
%lb 变量下边界
%dim 问题维数
%ouput
%X 果蝇X位置
%Y 果蝇Y位置
    X = zeros(pop, dim);
    Y = zeros(pop, dim);
    % 随机生成X坐标
    for i = 1:pop
        for j = 1:dim
            X(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
    % 随机生成Y坐标
    for i = 1:pop
        for j = 1:dim
            Y(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
    
end