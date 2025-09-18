function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best] = PSO(pop, dim, ub, lb, fobj, vmax, vmin, maxIter)
%input
%pop ��Ⱥ����
%dim ����ά��
%ub �����ϱ߽�
%lb �����±߽�
%fobj ��Ӧ�Ⱥ���
%vmax �����ٶ��ϱ߽�
%vmin �����ٶ��±߽�
%maxIter ��������
%output
%Best_pos ����ȫ������λ��
%Best_fitness ȫ������λ�ö�Ӧ����Ӧ�Ⱥ���ֵ
%Iter_curve ÿ�ε���������Ӧ��ֵ
%Histroy_pos ��¼ÿ������Ⱥλ��
%History_best ��¼ÿ������Ⱥ����λ��
if max(size(lb)) == 1
    lb = lb.*ones(1,dim);
    ub = ub.*ones(1,dim);
end
%% ����ѧϰ����c1,c2
c1 = 2;
c2 = 2.5;
w = 1;
wdamp = 0.99;
%% ��ʼ����Ⱥλ�ú��ٶ�
X = initialization(pop, ub, lb, dim);
V = initialization(pop, vmax, vmin, dim);
%% ������Ӧ��
fitness = zeros(1, pop);
for i = 1:pop
    fitness(i) = fobj(X(i,:));
end
%% ����ʼ��Ⱥ��Ϊ��ʷ����ֵ
pBest = X;
pBestFitness = fitness;
%% ��¼��ʼȫ������ֵ
% Ѱ����Ⱥ����Ӧ����С��λ��
[~, index] = min(fitness);
gBestFitness = fitness(index); %ȫ������fitness
gBest = X(index, :); %ȫ����������λ��
% λ��&��Ӧ�ȸ���
Xnew = X;
fitnessNew = fitness;
Iter_curve = zeros(1, maxIter);
%% ��ʼ����
for t = 1:maxIter
    for i = 1:pop
        % ��ÿ�������ٶȸ���
        r1 = rand(1, dim);
        r2 = rand(1, dim);
        V(i, :) = w*V(i, :) + c1 * r1 .* (pBest(i, :) - X(i, :)) + c2 * r2 .* (gBest - X(i, :));
        % �ٶȱ߽���
        V(i, :) = BoundaryCheck(V(i,:), vmax, vmin, dim);
        % λ�ø���&�߽���
        Xnew(i, :) = X(i, :) + V(i, :);
        Xnew(i, :) = BoundaryCheck(Xnew(i, :), ub, lb, dim);
        % ������Ӧ��
        fitnessNew(i) =  fobj(Xnew(i, :));
        % ��������i��ʷ����ֵ
        if fitnessNew(i) < pBestFitness(i)
            pBest(i, :) = Xnew(i, :);
            pBestFitness(i) = fitnessNew(i);
        end
        % ����ȫ������ֵ
        if fitnessNew(i) < gBestFitness
            gBestFitness = fitnessNew(i);
            gBest = Xnew(i, :);
        end
    end

    w = w*wdamp;
    % ���ϴε�����λ�ú���Ӧ�ȵ������ε�����ʼֵ
    X = Xnew;
    fitness = fitnessNew;
    % ��¼����λ�ú���Ӧ��
    Best_pos = gBest;
    Best_fitness = gBestFitness;
    Iter_curve(t) = gBestFitness;
    History_best{t} = Best_pos;
    History_pos{t} = X;
end
end
%%
function X = initialization(pop, ub, lb, dim)
%input
%pop ��Ⱥ����
%ub ÿ��γ�ȱ����ϱ߽�
%lb ÿ��γ�ȱ����±߽�
%dim ����γ��
%ouput
%X �����Ⱥ��sizeΪ[pop, dim]
    for i = 1:pop
        for j = 1:dim
            X(i, j) = (ub(j) - lb(j)) * rand() + lb(j);
        end
    end
end
%%
function X = BoundaryCheck(x, ub, lb, dim)
%x ��������
%ub �����ϱ߽�
%lb �����±߽�
%dim ά��
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

    
