% �߽��麯��
function X = BoundaryCheck(x, ub, lb, dim)
%input
%x �����Ӭ
%ub �����ϱ߽�
%lb �����±߽�
%dim ����ά��
%ouput
%X �Ϸ������Ӭ
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
