function main()
    pkg load statistics

    function myhist()

        centers = zeros(1, m);
        heights = zeros(1, m);

        for i = 1:m
            heights(i) = counts(i) / (n * delta);
        endfor

        for i = 1:m
            centers(i) = bins(i + 1) - (delta / 2);
        endfor

        fprintf("Высоты столбцов гистограммы:\n");
        for i = 1:m
            fprintf("%d-ый столбец : %f\n", i, heights(i));
        endfor

        set(gca, "xtick", bins);
        set(gca, "ytick", heights);
        set(gca, "xlim", [min(bins) - 1, max(bins) + 1]);
        bar(centers, heights, 1);
        
        nodes = (m_min - 5):(S / 250):(m_max + 5);
        %nodes = 0:(S /0):(m_max + 5);
        X_pdf = normpdf(nodes, mu, sqrt(S));
        plot(nodes, X_pdf, "r");
    end

    function mycdf()

        heights = zeros(1, m + 2);
        bins = [(min(bins) - 0.5) bins];
        counts = [0 counts 0];

        acc = 0;
        m = m + 2
        for i = 2:m
            acc = acc + counts(i);
            heights(i) = acc / n;
        end

        nodes = (m_min - 2):(S / 100):(m_max + 2);
        X_cdf = normcdf(nodes, mu, sqrt(S)))
        plot(nodes, X_cdf, "r");

        for i = 2:m
            fprintf("x = %f : F(x) = %f\n", bins(i), heights(i));
        end

        set(gca, "xtick", bins);
        set(gca, "ylim", [0, 1.5]);
        set(gca, "ytick", heights);
        stairs(bins, heights);
    end
    
    X = [-0.45,-0.33,2.92,-1.25,-1.20,0.05,-0.53,-0.19,1.49,0.67,0.22,1.23,0.50,-0.92,...
          0.90,-1.52,-0.15,-1.24,-0.47,-0.45,0.18,-0.05,1.58,1.74,2.37,-0.24,-1.34,1.05,...
          1.28,1.37,1.18,0.22,0.11,0.28,-0.64,-0.39,-1.77,-1.61,0.47,0.77,-0.27,-1.19,-0.25,...
          1.04,-0.16,0.42,0.29,0.10,1.04,0.43,-0.67,0.41,-0.62,-1.49,1.46,-2.77,2.09,0.88,...
          -0.36,-0.71,-0.62,1.34,-0.78,-0.15,2.69,0.92,1.68,-0.12,0.34,0.74,1.72,1.24,0.23,...
          0.76,0.87,-1.52,0.63,-0.56,0.83,0.31,-0.18,0.99,-1.01,0.58,1.21,-1.51,0.65,0.35,...
          -0.37,-0.50,-0.73,0.63,0.33,1.56,-0.98,0.85,0.56,-1.07,1.47,1.44,1.91,0.24,1.34,...
          0.99,1.27,0.11,0.22,-0.25,0.35,-0.03,-0.56,-0.79,2.41,-0.45,-0.44,0.07,0.64,0.69,...
          0.10,-0.28, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ,4 ,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4]
    
   
    X = sort(X);

    % вычисление максимального и минимального значения
    
    m_max = max(X);
    m_min = min(X);
    fprintf("----------------------------------------\n");
    fprintf("1. Максимальное значение выборки: M_max = %f.\n", m_max);
    fprintf("   Минимальное значение выборки:  M_min = %f.\n", m_min);
    fprintf("----------------------------------------\n");

    % Вычисление размаха выборки
    
    r = m_max - m_min;
    h = r / 8
    fprintf("2. Размах выборки: R = %f.\n", r);
    fprintf("----------------------------------------\n");

    % Вычисление оценок математического ожидания и дисперсии
    
    n = length(X);
    mu = sum(X) / n;
    S = sum((X - mu).^2) / (n - 1);
    fprintf("3. Оценка математического ожидания: m = %f.\n", mu);
    fprintf("   Оценка дисперсии: S^2 = %f.\n", S);
    fprintf("----------------------------------------\n");

    % Группировка значений выборки в m = [log_2 n] + 2 интервала
    
    m = floor(log2(n)) + 2;
    bins = [];
    cur = m_min;
    delta = r / m 

    for i = 1:(m + 1)
        bins(i) = cur;
        cur = cur + delta;
    end

    eps = 1e-6;
    counts = [];

    for i = 1:(m - 1)
        cur = 0;

        for j = 1:n
            if ((X(j) - eps) > bins(i) || abs(bins(i) - X(j)) < eps) && X(j) < (bins(i + 1) - eps)
                cur = cur + 1;
            endif
        endfor

        counts(i) = cur;
    endfor

    cur = 0;
    for i = 1:n
        if (bins(m) < X(i) || abs(bins(m) - X(i)) < eps) && (X(i) < bins(m + 1) || abs(bins(m + 1) - X(i)) < eps)
            cur = cur + 1;
        endif
    endfor

    counts(m) = cur;

    fprintf("4. Группировка значений выборки в %d интервалов:\n", m);
    for i = 1:(m)
        fprintf("Интервал №%d [%f : %f) - %d значений из выборки.\n", i, bins(i), bins(i + 1), counts(i));
    end
    fprintf("----------------------------------------\n");

    % Построение гистограммы и функции плотности распределения нормальной СВ.

    fprintf("5. Построение гистограммы и графика функции плотности распределения нормальной СВ.\n");
    figure;
    hold on;
    grid on;
    myhist();
    xlabel('X')
    ylabel('P')
    print -djpg hist.jpg
    hold off;
    fprintf("----------------------------------------\n");

    % Построение графика эмпирической функции распределения и функции распределения нормальной СВ.
    fprintf("6. Построение графика эмпирической функции распределения и функции распределения нормальной СВ.\n");
    figure;
    hold on;
    grid on;
    mycdf(X, bins, counts);
    xlabel('X')
    ylabel('F')
    print -djpg cdf.jpg
    hold off;
end

main()