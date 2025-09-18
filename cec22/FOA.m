% ��Ӭ�Ż��㷨
function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best, BestX, BestY] = FOA(pop, dim, ub, lb, fobj, maxIter)
%pop ��Ⱥ����
%dim ����ά��
%ub �����ϱ߽�
%lb �����±߽�
%maxIter ����������
%ouput
%Best_pos ȫ�ֹ�Ӭ����λ��
%Best_fitness ȫ������λ�ö�Ӧ����Ӧ��ֵ
%Iter_curve ÿ��������Ӧ��ֵ
%History_pos ÿ����Ӭ��Ⱥλ��
%History_best ÿ�����Ź�Ӭλ��
%BestX ���Ź�Ӭλ��X����
%BestY ���Ź�Ӭλ��Y����
%% �㷨��ʼ��
% ��Ӭλ�ó�ʼ�� 
for i = 1:dim
    X_axis(:,i) = lb(i)+rand(pop,1)*(ub(i)-lb(i));
    Y_axis(:,i) = lb(i)+rand(pop,1)*(ub(i)-lb(i));
end
% ������Ӧ��ֵ��ʼ��
Best_fitness = inf;
% ������ʼ��
X = zeros(pop, dim);
Y = zeros(pop, dim);
S = zeros(pop, dim);
Dist = zeros(pop, dim);
Smell = zeros(1, pop);
Iter_curve = zeros(1, maxIter);
%% ����
for t = 1:maxIter
    for i = 1:pop
        % ��Ӭͨ����ζȷ��ʳ�﷽��
        X(i,:) = X_axis(i,:) + 2 * rand(1, dim) - 1;
        Y(i,:) = Y_axis(i,:) + 2 * rand(1, dim) - 1;
        % �������
        Dist(i,:) = (X(i,:).^2 + Y(i,:).^2).^0.5;
        S(i,:) = 1./Dist(i,:);
        % ���߽�
        Flag4ub=S(i,:)>ub;
        Flag4lb=S(i,:)<lb;
        S(i,:)=(S(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        % ����Ũ��
        Smell(i) = fobj(S(i,:));
    end
    % ������Ӧ��ֵ&λ��
    [bestSmell, bestIndex] = min(Smell);
    % ����λ��
    for i = 1:pop
        X_axis(i,:) = X(bestIndex,:);
        Y_axis(i,:) = Y(bestIndex,:);
    end
    if bestSmell < Best_fitness
        Best_fitness = bestSmell;
        Best_pos = S(bestIndex,:);
    end
    BestXTemp = X(bestIndex,:);
    BestYTemp = Y(bestIndex,:);
    %��¼����ֵ
    History_pos{t} = S;
    History_best{t} = Best_pos;
    BestX{t} = BestXTemp;
    BestY{t} = BestYTemp;
    Iter_curve(t) = Best_fitness;
end
end
