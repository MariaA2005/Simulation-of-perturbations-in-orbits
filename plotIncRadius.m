function plotIncRadius(orbitNominal, varargin)

    numOrbits = length(varargin);

    colors = {'#D95319', '#EDB120', '#7E2F8E', ...
              '#77AC30', '#4DBEEE', '#A2142F'};

    figure('Name', 'Comparative Perturbation Matrix', ...
           'Color', 'w');

    for i = 1:numOrbits

        nombreVariable = inputname(i + 1);

        if isempty(nombreVariable)
            nombreVariable = sprintf('Orbit %d', i);
        end

        label_name = sprintf('Perturbed: %s', nombreVariable);

        orbitP = varargin{i};

        color_idx = mod(i-1, length(colors)) + 1;

        %% COLUMNA 1: INCLINACIÓN
        subplot(numOrbits, 2, (i-1)*2 + 1);

        plot(orbitNominal.t/3600, orbitNominal.inc, ...
             'b', 'LineWidth', 1.5, ...
             'DisplayName', 'Ideal');
        hold on;

        plot(orbitP.t/3600, orbitP.inc, '--', ...
             'Color', colors{color_idx}, ...
             'LineWidth', 1.2, ...
             'DisplayName', label_name);

        all_inc = [orbitNominal.inc(:); orbitP.inc(:)];

        min_inc = min(all_inc);
        max_inc = max(all_inc);

        range_inc = max_inc - min_inc;

        if range_inc == 0
            ylim([min_inc - 0.05, min_inc + 0.05]);
        else
            ylim([min_inc - 0.1*range_inc, ...
                  max_inc + 0.1*range_inc]);
        end

        title(sprintf('Inclination - %s', nombreVariable));
        ylabel('i (degrees)');
        xlabel('Time (hours)');
        legend('Location', 'best');
        grid on;

        %% COLUMNA 2: RADIO ORBITAL
        subplot(numOrbits, 2, (i-1)*2 + 2);

        plot(orbitNominal.t/3600, orbitNominal.radiusNorm, ...
             'b', 'LineWidth', 1.5, ...
             'DisplayName', 'Ideal');
        hold on;

        plot(orbitP.t/3600, orbitP.radiusNorm, '--', ...
             'Color', colors{color_idx}, ...
             'LineWidth', 1.2, ...
             'DisplayName', label_name);

        all_rad = [orbitNominal.radiusNorm(:); orbitP.radiusNorm(:)];

        min_rad = min(all_rad);
        max_rad = max(all_rad);

        range_rad = max_rad - min_rad;

        if range_rad == 0
            ylim([min_rad - 1, min_rad + 1]);
        else
            ylim([min_rad - 0.1*range_rad, ...
                  max_rad + 0.1*range_rad]);
        end

        title(sprintf('Orbital Radius - %s', nombreVariable));
        ylabel('|r| (km)');
        xlabel('Time (hours)');
        legend('Location', 'best');
        grid on;

    end

end