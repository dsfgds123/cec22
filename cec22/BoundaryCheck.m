% 边界检查函数
function X = BoundaryCheck(x, ub, lb, dim)
%input
%x 单体果蝇
%ub 变量上边界
%lb 变量下边界
%dim 问题维数
%ouput
%X 合法单体果蝇
    for i = 1:dim
        if x(i) > ub(i)
            x(i) = ub(i);
        end
        if x(i) < lb(i)
            x(i) = lb(i);
        end
    end
    X = x;
end
