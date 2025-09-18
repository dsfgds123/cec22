% ө����Ż��㷨
function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best] = FA(pop, dim, ub, lb, fobj, maxIter)
%input
%pop ��Ⱥ����
%dim ����ά��
%ub �����ϱ߽�
%lb �����±߽�
%fobj ��Ӧ�Ⱥ���
%maxIter ����������
%output
%Best_pos ����λ��
%Best_fitness ������Ӧ��ֵ
%Iter_curve ÿ��������Ӧ��ֵ
%History_pos ÿ����Ⱥλ��
%History_best ÿ������ө���λ��
%% ө����Ż��㷨����
beta0 = 2; %���������
gamma = 1; %��ǿ����ϵ��
alpha = 0.2; %��������
alpha_damp = 0.98; % �����½�����
dmax = norm(ub - lb); %�ռ�������
%% ��ʼ��ө���λ��
X = zeros(pop, dim);
for i = 1:pop
    for j = 1:dim
        X(i,j) = (ub(j) - lb(j)) * rand() + lb(j);
    end
end
%% ��ʼ����Ӧ��ֵ
fitness = zeros(1,pop);
for i = 1:pop
    fitness(i) = fobj(X(i,:));
end
%% ��¼ȫ�����Ž�
[~, index] = min(fitness);
gBestFitness = fitness(index);
gBest = X(index,:);
Xnew = X;
%% ����
for t = 1:maxIter
    for i = 1:pop
        for j = 1:pop
            if fitness(j) < fitness(i)
                %�������
                rij = norm(X(i,:) - X(j,:))./dmax;
                %����������
                beta = beta0 * exp(-gamma * rij^2);
                %����λ��
                newSolution = X(i,:) + beta * rand(1,dim).*(X(j,:) - X(i,:)) + alpha.*rand(1,dim);
                %�߽���
                for k = 1:dim
                    if newSolution(k) > ub(k)
                        newSolution(k) = ub(k);
                    end
                    if newSolution(k) < lb(k)
                        newSolution(k) = lb(k);
                    end
                end
                newSFitness = fobj(newSolution);
                %����ө���λ��
                if newSFitness < fitness(i)
                    Xnew(i,:) = newSolution;
                    fitness(i) = newSFitness;
                    if newSFitness < gBestFitness
                        gBestFitness = newSFitness;
                        gBest = newSolution;
                    end
                end
            end
        end
    end
    %��λ������ʷλ�úϲ�
    P = [X;Xnew];
    for i = 1:2*pop
        Pfit(i) = fobj(P(i,:));
    end
    [~, sortIndex] = sort(Pfit); %��Ӧ������
    X = P(sortIndex(1:pop),:); %ȡ��ǰ��popֻө�����Ϊ�´ε�����ʼ��Ⱥ
    %��¼����
    Iter_curve(t) = gBestFitness;
    History_pos{t} = X;
    History_best{t} = gBest;
end
Best_pos = gBest;
Best_fitness = gBestFitness;
end
