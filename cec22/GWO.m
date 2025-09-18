% %___________________________________________________________________%
% %  Grey Wolf Optimizer (GWO) source codes version 1.0               %
% %                                                                   %
% %  Developed in MATLAB R2011b(7.13)                                 %
% %                                                                   %
% %  Author and programmer: Seyedali Mirjalili                        %
% %                                                                   %
% %         e-Mail: ali.mirjalili@gmail.com                           %
% %                 seyedali.mirjalili@griffithuni.edu.au             %
% %                                                                   %
% %       Homepage: http://www.alimirjalili.com                       %
% %                                                                   %
% %   Main paper: S. Mirjalili, S. M. Mirjalili, A. Lewis             %
% %               Grey Wolf Optimizer, Advances in Engineering        %
% %               Software , in press,                                %
% %               DOI: 10.1016/j.advengsoft.2013.12.007               %
% %                                                                   %
% %___________________________________________________________________%
% 
% % Grey Wolf Optimizer
% % 该函数实现了灰狼优化算法，用于求解目标函数的最优值
% % 输入参数:
% % SearchAgents_no: 搜索代理（灰狼）的数量
% % Max_iter: 最大迭代次数
% % lb: 变量的下界
% % ub: 变量的上界
% % dim: 变量的维度
% % fobj: 目标函数句柄
% % 输出参数:
% % Alpha_score: 最优解的目标函数值
% % Alpha_pos: 最优解的位置
% % Convergence_curve: 收敛曲线，记录每次迭代的最优目标函数值
% function [Alpha_score,Alpha_pos,Convergence_curve]=GWO(SearchAgents_no,Max_iter,lb,ub,dim,fobj)
% 
% % initialize alpha, beta, and delta_pos
% % 初始化 Alpha 狼的位置和适应度值
% % Alpha 狼代表当前找到的最优解
% Alpha_pos=zeros(1,dim);
% Alpha_score=inf; % 初始化为无穷大，若为最大化问题，需改为 -inf
% % 初始化 Beta 狼的位置和适应度值
% % Beta 狼代表当前找到的次优解
% Beta_pos=zeros(1,dim);
% Beta_score=inf; % 初始化为无穷大，若为最大化问题，需改为 -inf
% % 初始化 Delta 狼的位置和适应度值
% % Delta 狼代表当前找到的第三优解
% Delta_pos=zeros(1,dim);
% Delta_score=inf; % 初始化为无穷大，若为最大化问题，需改为 -inf
% 
% %Initialize the positions of search agents
% % 调用 initialization 函数初始化所有搜索代理（灰狼）的位置
% Positions=initialization(SearchAgents_no,dim,ub,lb);
% 
% % 初始化收敛曲线，用于记录每次迭代的最优目标函数值
% Convergence_curve=zeros(1,Max_iter);
% 
% % 初始化迭代计数器
% l=0; 
% 
% % Main loop
% % 主循环，直到达到最大迭代次数
% while l<Max_iter
%     % 遍历每个搜索代理（灰狼）
%     for i=1:size(Positions,1)  
%         % Return back the search agents that go beyond the boundaries of the search space
%         % 检查搜索代理是否超出搜索空间的上界
%         Flag4ub=Positions(i,:)>ub;
%         % 检查搜索代理是否超出搜索空间的下界
%         Flag4lb=Positions(i,:)<lb;
%         % 将超出边界的搜索代理拉回到搜索空间内
%         Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;               
% 
%         % Calculate objective function for each search agent
%         % 计算当前搜索代理的目标函数值
%         fitness=fobj(Positions(i,:));
% 
%         % Update Alpha, Beta, and Delta
%         % 如果当前搜索代理的适应度值优于 Alpha 狼的适应度值
%         if fitness<Alpha_score 
%             % 更新 Alpha 狼的适应度值
%             Alpha_score=fitness; 
%             % 更新 Alpha 狼的位置
%             Alpha_pos=Positions(i,:);
%         end
% 
%         % 如果当前搜索代理的适应度值介于 Alpha 狼和 Beta 狼之间
%         if fitness>Alpha_score && fitness<Beta_score 
%             % 更新 Beta 狼的适应度值
%             Beta_score=fitness; 
%             % 更新 Beta 狼的位置
%             Beta_pos=Positions(i,:);
%         end
% 
%         % 如果当前搜索代理的适应度值介于 Beta 狼和 Delta 狼之间
%         if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score 
%             % 更新 Delta 狼的适应度值
%             Delta_score=fitness; 
%             % 更新 Delta 狼的位置
%             Delta_pos=Positions(i,:);
%         end
%     end
% 
%     % 计算控制参数 a，它随迭代次数线性从 2 减小到 0
%     a=2-l*((2)/Max_iter); 
% 
%     % Update the Position of search agents including omegas
%     % 遍历每个搜索代理（灰狼）
%     for i=1:size(Positions,1)
%         % 遍历每个变量维度
%         for j=1:size(Positions,2)     
%             % 生成一个 [0, 1] 之间的随机数
%             r1=rand(); 
%             % 生成一个 [0, 1] 之间的随机数
%             r2=rand(); 
% 
%             % 根据公式 (3.3) 计算 A1
%             A1=2*a*r1-a; 
%             % 根据公式 (3.4) 计算 C1
%             C1=2*r2; 
% 
%             % 根据公式 (3.5) 计算当前搜索代理到 Alpha 狼的距离
%             D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); 
%             % 根据公式 (3.6) 计算当前搜索代理向 Alpha 狼移动的位置
%             X1=Alpha_pos(j)-A1*D_alpha; 
% 
%             % 生成一个 [0, 1] 之间的随机数
%             r1=rand();
%             % 生成一个 [0, 1] 之间的随机数
%             r2=rand();
% 
%             % 根据公式 (3.3) 计算 A2
%             A2=2*a*r1-a; 
%             % 根据公式 (3.4) 计算 C2
%             C2=2*r2; 
% 
%             % 根据公式 (3.5) 计算当前搜索代理到 Beta 狼的距离
%             D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); 
%             % 根据公式 (3.6) 计算当前搜索代理向 Beta 狼移动的位置
%             X2=Beta_pos(j)-A2*D_beta; 
% 
%             % 生成一个 [0, 1] 之间的随机数
%             r1=rand();
%             % 生成一个 [0, 1] 之间的随机数
%             r2=rand(); 
% 
%             % 根据公式 (3.3) 计算 A3
%             A3=2*a*r1-a; 
%             % 根据公式 (3.4) 计算 C3
%             C3=2*r2; 
% 
%             % 根据公式 (3.5) 计算当前搜索代理到 Delta 狼的距离
%             D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); 
%             % 根据公式 (3.5) 计算当前搜索代理向 Delta 狼移动的位置
%             X3=Delta_pos(j)-A3*D_delta; 
% 
%             % 根据公式 (3.7) 更新当前搜索代理的位置
%             Positions(i,j)=(X1+X2+X3)/3;
%         end
%     end
%     % 迭代计数器加 1
%     l=l+1;    
%     % 记录当前迭代的最优目标函数值
%     Convergence_curve(l)=Alpha_score;
% end
function [Alpha_score, Alpha_pos, Best_curve, Avg_curve, Worst_curve] = GWO(SearchAgents_no, Max_iter, lb, ub, dim, fobj)
% =================================================================================================
%                      GWO (Grey Wolf Optimizer) - v2.0
%   此版本经过修改，可输出每代种群的最佳、平均、最差适应度值
% =================================================================================================

% 初始化 Alpha, Beta, Delta 狼
Alpha_pos=zeros(1,dim); Alpha_score=inf;
Beta_pos=zeros(1,dim); Beta_score=inf;
Delta_pos=zeros(1,dim); Delta_score=inf;

% 初始化种群位置
Positions=initialization_GWO(SearchAgents_no,dim,ub,lb);

% --- 【修改】初始化详细的收敛曲线记录数组 ---
Best_curve = zeros(1, Max_iter);
Avg_curve = zeros(1, Max_iter);
Worst_curve = zeros(1, Max_iter);

l=0;
while l<Max_iter
    % 【修改】预分配一个数组来存储当前代所有个体的适应度
    all_fitness = zeros(SearchAgents_no, 1);
    
    for i=1:size(Positions,1)
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb;
        
        % 计算并存储适应度
        fitness=fobj(Positions(i,:));
        all_fitness(i) = fitness; % 存入数组
        
        % 更新 Alpha, Beta, Delta
        if fitness<Alpha_score
            Alpha_score=fitness;
            Alpha_pos=Positions(i,:);
        end
        if fitness>Alpha_score && fitness<Beta_score
            Beta_score=fitness;
            Beta_pos=Positions(i,:);
        end
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score
            Delta_score=fitness;
            Delta_pos=Positions(i,:);
        end
    end
    
    % 【新增】在评估后，记录当前种群的统计信息
    Best_curve(l+1) = min(all_fitness); % 或者用 Alpha_score
    Avg_curve(l+1) = mean(all_fitness);
    Worst_curve(l+1) = max(all_fitness);
    
    % a=2-l*((2)/Max_iter);
     % 新的非线性递减策略，让 a 在前期保持较大值更久，鼓励探索
    a = 2 * (1 - (l/Max_iter)^2);
    % (后续的位置更新代码保持不变)
    for i=1:size(Positions,1)
        for j=1:size(Positions,2)
            r1=rand(); r2=rand();
            A1=2*a*r1-a; C1=2*r2;
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j));
            X1=Alpha_pos(j)-A1*D_alpha;
            
            r1=rand(); r2=rand();
            A2=2*a*r1-a; C2=2*r2;
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j));
            X2=Beta_pos(j)-A2*D_beta;
            
            r1=rand(); r2=rand();
            A3=2*a*r1-a; C3=2*r2;
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j));
            X3=Delta_pos(j)-A3*D_delta;
            
            Positions(i,j)=(X1+X2+X3)/3;
        end
    end
    l=l+1;
end
end