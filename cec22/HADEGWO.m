% 萤火虫优化算法
function [Best_pos, Best_fitness, Iter_curve, History_pos, History_best] = FA(pop, dim, ub, lb, fobj, maxIter)
%input
%pop 种群数量
%dim 问题维数
%ub 变量上边界
%lb 变量下边界
%fobj 适应度函数
%maxIter 最大迭代次数
%output
%Best_pos 最优位置
%Best_fitness 最优适应度值
%Iter_curve 每代最优适应度值
%History_pos 每代种群位置
%History_best 每代最优萤火虫位置
%% 萤火虫优化算法参数
beta0 = 2; %最大吸引度
gamma = 1; %光强吸收系数
alpha = 0.2; %步长因子
alpha_damp = 0.98; % 步长下降因子
dmax = norm(ub - lb); %空间最大距离
%% 初始化萤火虫位置
X = zeros(pop, dim);
for i = 1:pop
    for j = 1:dim
        X(i,j) = (ub(j) - lb(j)) * rand() + lb(j);
    end
end
%% 初始化适应度值
fitness = zeros(1,pop);
for i = 1:pop
    fitness(i) = fobj(X(i,:));
end
%% 记录全局最优解
[~, index] = min(fitness);
gBestFitness = fitness(index);
gBest = X(index,:);
Xnew = X;
%% 迭代
for t = 1:maxIter
    for i = 1:pop
        for j = 1:pop
            if fitness(j) < fitness(i)
                %计算距离
                rij = norm(X(i,:) - X(j,:))./dmax;
                %计算吸引度
                beta = beta0 * exp(-gamma * rij^2);
                %更新位置
                newSolution = X(i,:) + beta * rand(1,dim).*(X(j,:) - X(i,:)) + alpha.*rand(1,dim);
                %边界检查
                for k = 1:dim
                    if newSolution(k) > ub(k)
                        newSolution(k) = ub(k);
                    end
                    if newSolution(k) < lb(k)
                        newSolution(k) = lb(k);
                    end
                end
                newSFitness = fobj(newSolution);
                %更新萤火虫位置
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
    %新位置与历史位置合并
    P = [X;Xnew];
    for i = 1:2*pop
        Pfit(i) = fobj(P(i,:));
    end
    [~, sortIndex] = sort(Pfit); %适应度排序
    X = P(sortIndex(1:pop),:); %取靠前的pop只萤火虫作为下次迭代初始种群
    %记录数据
    Iter_curve(t) = gBestFitness;
    History_pos{t} = X;
    History_best{t} = gBest;
end
Best_pos = gBest;
Best_fitness = gBestFitness;
end
