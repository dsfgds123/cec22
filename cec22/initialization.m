% ��Ӭλ�ó�ʼ������
function [X, Y] = initialization(pop, ub, lb, dim)
%input
%pop ��Ⱥ����
%ub �����ϱ߽�
%lb �����±߽�
%dim ����ά��
%ouput
%X ��ӬXλ��
%Y ��ӬYλ��
    X = zeros(pop, dim);
    Y = zeros(pop, dim);
    % �������X����
    for i = 1:pop
        for j = 1:dim
            X(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
    % �������Y����
    for i = 1:pop
        for j = 1:dim
            Y(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
    
end