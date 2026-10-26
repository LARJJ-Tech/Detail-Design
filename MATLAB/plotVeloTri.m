function plotVeloTri(velo, blade, profile, component)
% VELOTRIPLOT Plot compressor or turbine velocity triangles.
%
% Usage Example
% ########################################################################
%   veloT = readtable('Clardy, John S.''s files - LARJJ Tech\Component_Aero.xlsx',Sheet='LPT');
%   bladeT = readtable('Clardy, John S.''s files - LARJJ Tech\Component_Blading.xlsx',Sheet='LPT');
%   profileT = readtable("Clardy, John S.'s files - LARJJ Tech\Component_BladeProfiles.xlsx",Sheet="Turbine");
%   plotVeloTri(velo, blade, profile, 't')
% ########################################################################
%
% Layout
%   Columns = stages.
%   Rows    = Hub, Mid, Tip.
%   Identical square limits across all panels.
%   Axis labels and numeric values are hidden.
%   Figure height = 900 pixels.
%
% Blade order
%   Compressor: rotor, stator.
%   Turbine:    stator, rotor.
%
% Profile treatment
%   Compressor rotor: inverted local y/c coordinates.
%   Stators: camber-line tangents match absolute flow angles.
%   Turbine rotor: camber-line tangents match relative flow angles.
%
% Turbine interstage matching
%   The downstream stator-inlet absolute-flow angle is set equal to
%   the preceding rotor-exit angle, preserving downstream inlet Vax.
%   This overrides the downstream inlet tangential velocity and speed.
%
% Geometry
%   Camber-line matching is an illustrative plotting construction,
%   not an aerodynamic blade redesign.
%
% Convention
%   Horizontal = axial; vertical = tangential.
%   V = W + U.
%   Positive tangential velocity follows rotor rotation.
%
% Colors
%   V = blue, Vax = black, W = green, U = red.

isTurbine = strcmpi(component, 't');

% Automatically map consecutive stage data.
%
% Each stage uses:
%   3 velocity rows: inlet, inter-row station, outlet
%   2 blade rows: first blade, second blade
%
% An optional fifth input overrides this mapping.

if nargin < 5 || isempty(stageMap)

    nStages = min( ...
        floor(height(velo) / 3), ...
        floor(height(blade) / 2));

    stageIndex = (0:nStages-1).';

    stageMap = [
        3*stageIndex + 1, ...
        3*stageIndex + 2, ...
        3*stageIndex + 3, ...
        2*stageIndex + 1, ...
        2*stageIndex + 2
        ];
end


locations = {'Tip', 'Mid', 'Hub'};

% Default signs where speed magnitudes cannot determine swirl sign.
swirlSign = [1; 1; 1];

col.V      = [0.25, 0.44, 0.75];
col.Vax    = [0.00, 0.00, 0.00];
col.W      = [0.30, 0.65, 0.20];
col.U      = [0.90, 0.05, 0.05];
col.rotor  = [0.25, 0.44, 0.75];
col.stator = [0.93, 0.48, 0.16];

if istable(profile)
    P = profile{:, 1:2};
else
    P = profile;
end

nStages = size(stageMap, 1);
data = cell(nStages, 3);
plotAxes = gobjects(3, nStages);

if isTurbine
    rotorStations = [2, 3];
    componentName = 'Turbine';
else
    rotorStations = [1, 2];
    componentName = 'Compressor';
end

%% Prepare velocity data

maxChord = 0;

for s = 1:nStages

    vRows = stageMap(s, 1:3);
    bRows = stageMap(s, 4:5);

    for k = 1:3

        loc = locations{k};

        ca = velo{vRows, ['Vax', loc]};
        vm = velo{vRows, ['V', loc]};
        wm = velo{vRows, ['W', loc]};
        u  = velo{vRows, ['U', loc]};

        ca = ca(:);
        vm = vm(:);
        wm = wm(:);
        u  = u(:);

        ctAbs = sqrt(max(vm.^2 - ca.^2, 0));
        ct = swirlSign .* ctAbs;

        % Choose swirl sign using supplied relative-speed magnitudes.
        for j = rotorStations
            if abs(u(j)) > 1e-10 && wm(j) > 0
                candidates = [ctAbs(j), -ctAbs(j)];
                predictedW = hypot(ca(j), candidates - u(j));

                [~, best] = min(abs(predictedW - wm(j)));
                ct(j) = candidates(best);
            end
        end

        D.V = [ca, ct];
        D.W = [ca, ct - u];
        D.u = u;
        D.chord = blade{bRows, ['c', loc]};
        D.stagger = blade{bRows, ['st', loc]};

        maxChord = max(maxChord, max(D.chord));
        data{s, k} = D;
    end
end

%% Match turbine interstage absolute-flow directions
% Preserve downstream inlet Vax and use upstream rotor-exit angle.

if isTurbine
    for s = 2:nStages
        for k = 1:3

            upstream = data{s-1, k};
            downstream = data{s, k};

            exitAngle = atan2( ...
                upstream.V(3, 2), upstream.V(3, 1));

            downstream.V(1, 2) = ...
                downstream.V(1, 1) * tan(exitAngle);

            downstream.W(1, :) = ...
                downstream.V(1, :) - [0, downstream.u(1)];

            data{s, k} = downstream;
        end
    end
end

%% Determine one common velocity-to-length scale

maxSpeed = 0;

for s = 1:nStages
    for k = 1:3

        D = data{s, k};

        speeds = [
            hypot(D.V(:, 1), D.V(:, 2))
            hypot(D.W(rotorStations, 1), ...
            D.W(rotorStations, 2))
            abs(D.u(rotorStations))
            ];

        maxSpeed = max(maxSpeed, max(speeds));
    end
end

scale = 0.55 * maxChord / maxSpeed;

%% Prepare blade geometry, arrows, and global bounds

allPoints = [];

for s = 1:nStages
    for k = 1:3

        D = data{s, k};
        D.firstLE = [0, 0];

        if isTurbine

            % First blade: stator, matching absolute flow angles.
            firstFlow = D.V(1:2, :);

            D.firstAngle = mean(atan2d( ...
                firstFlow(:, 2), firstFlow(:, 1)));

            D.firstXY = matchedProfile( ...
                P, D.chord(1), D.firstAngle, ...
                D.firstLE, firstFlow);

            D.firstTE = D.firstLE + D.chord(1) * ...
                [cosd(D.firstAngle), sind(D.firstAngle)];

            % Anchor the inter-row triangle at stator trailing edge.
            inletOrigin = D.firstTE;

            % Relative inlet velocity ends at rotor leading edge.
            D.secondLE = inletOrigin + scale * D.W(2, :);

            % Second blade: rotor, matching relative flow angles.
            secondFlow = D.W(2:3, :);

            D.secondAngle = mean(atan2d( ...
                secondFlow(:, 2), secondFlow(:, 1)));

            D.secondXY = matchedProfile( ...
                P, D.chord(2), D.secondAngle, ...
                D.secondLE, secondFlow);

            D.secondTE = D.secondLE + D.chord(2) * ...
                [cosd(D.secondAngle), sind(D.secondAngle)];

            % Absolute velocities.
            D.vArrows = [
                D.firstLE - scale*D.V(1, :), scale*D.V(1, :)
                inletOrigin,                scale*D.V(2, :)
                D.secondTE,                 scale*D.V(3, :)
                ];

            % Relative velocities.
            D.wArrows = [
                inletOrigin, scale*D.W(2, :)
                D.secondTE,  scale*D.W(3, :)
                ];

            % Blade-speed vectors close V = W + U.
            D.uArrows = [
                D.secondLE,                  scale*[0, D.u(2)]
                D.secondTE + scale*D.W(3, :), scale*[0, D.u(3)]
                ];

        else

            % First blade: compressor rotor, inverted profile.
            rotorDirection = sign(mean(D.W(1:2, 2)));
            statorDirection = sign(mean(D.V(2:3, 2)));

            if rotorDirection == 0
                rotorDirection = 1;
            end

            if statorDirection == 0
                statorDirection = 1;
            end

            D.firstAngle = rotorDirection * abs(D.stagger(1));
            D.secondAngle = statorDirection * abs(D.stagger(2));

            invertedProfile = [P(:, 1), -P(:, 2)];

            D.firstXY = placeProfile( ...
                invertedProfile, D.chord(1), ...
                D.firstAngle, D.firstLE);

            D.firstTE = D.firstLE + D.chord(1) * ...
                [cosd(D.firstAngle), sind(D.firstAngle)];

            % Rotor-exit absolute velocity ends at stator LE.
            D.secondLE = D.firstTE + scale * D.V(2, :);

            % Second blade: stator, matching absolute flow angles.
            D.secondXY = matchedProfile( ...
                P, D.chord(2), D.secondAngle, ...
                D.secondLE, D.V(2:3, :));

            D.secondTE = D.secondLE + D.chord(2) * ...
                [cosd(D.secondAngle), sind(D.secondAngle)];

            inletOrigin = D.firstLE - scale * D.W(1, :);

            D.vArrows = [
                inletOrigin, scale*D.V(1, :)
                D.firstTE,   scale*D.V(2, :)
                D.secondTE,  scale*D.V(3, :)
                ];

            D.wArrows = [
                inletOrigin, scale*D.W(1, :)
                D.firstTE,   scale*D.W(2, :)
                ];

            D.uArrows = [
                D.firstLE,                  scale*[0, D.u(1)]
                D.firstTE + scale*D.W(2, :), scale*[0, D.u(2)]
                ];
        end

        % Axial components share absolute-vector origins.
        D.axArrows = D.vArrows;
        D.axArrows(:, 4) = 0;

        arrows = [
            D.vArrows
            D.axArrows
            D.wArrows
            D.uArrows
            ];

        allPoints = [
            allPoints
            D.firstXY
            D.secondXY
            arrows(:, 1:2)
            arrows(:, 1:2) + arrows(:, 3:4)
            ];

        data{s, k} = D;
    end
end

%% Identical square limits across all panels

xBounds = [min(allPoints(:, 1)), max(allPoints(:, 1))];
yBounds = [min(allPoints(:, 2)), max(allPoints(:, 2))];

span = 1.08 * max([diff(xBounds), diff(yBounds)]);

xLimits = mean(xBounds) + [-0.5, 0.5] * span;
yLimits = mean(yBounds) + [-0.5, 0.5] * span;

xTicks = linspace(xLimits(1), xLimits(2), 6);
yTicks = linspace(yLimits(1), yLimits(2), 6);

%% Create compact 3-by-nStages figure

fig = figure( ...
    'Color', 'w', ...
    'Name', [componentName, ' Velocity Triangles'], ...
    'Units', 'pixels', ...
    'Position', [50, 50, max(400, 280*nStages), 900]);

layout = tiledlayout(fig, 3, nStages, ...
    'TileSpacing', 'tight', ...
    'Padding', 'compact');

for s = 1:nStages
    for k = 1:3

        D = data{s, k};

        ax = nexttile(layout, (k - 1)*nStages + s);
        plotAxes(k, s) = ax;
        hold(ax, 'on');

        if isTurbine
            hStator = plot(ax, ...
                D.firstXY(:, 1), D.firstXY(:, 2), ...
                'Color', col.stator, 'LineWidth', 1.8);

            hRotor = plot(ax, ...
                D.secondXY(:, 1), D.secondXY(:, 2), ...
                'Color', col.rotor, 'LineWidth', 1.8);
        else
            hRotor = plot(ax, ...
                D.firstXY(:, 1), D.firstXY(:, 2), ...
                'Color', col.rotor, 'LineWidth', 1.8);

            hStator = plot(ax, ...
                D.secondXY(:, 1), D.secondXY(:, 2), ...
                'Color', col.stator, 'LineWidth', 1.8);
        end

        hV = drawArrows(ax, D.vArrows, col.V);
        hVax = drawArrows(ax, D.axArrows, col.Vax);
        hW = drawArrows(ax, D.wArrows, col.W);
        hU = drawArrows(ax, D.uArrows, col.U);

        if k == 1
            title(ax, {sprintf('STAGE %d', s), ...
                upper(locations{k})}, 'FontSize', 11);
        else
            title(ax, upper(locations{k}), 'FontSize', 11);
        end

        xlim(ax, xLimits);
        ylim(ax, yLimits);

        daspect(ax, [1, 1, 1]);
        pbaspect(ax, [1, 1, 1]);

        set(ax, ...
            'XTick', xTicks, ...
            'YTick', yTicks, ...
            'XTickLabel', [], ...
            'YTickLabel', [], ...
            'TickLength', [0, 0], ...
            'FontSize', 10, ...
            'Layer', 'top');

        grid(ax, 'on');
        box(ax, 'on');

        if s == 1 && k == 1
            lgd = legend(ax, ...
                [hRotor, hStator, hV, hVax, hW, hU], ...
                {'Rotor', 'Stator', 'V: absolute', ...
                'Vax: axial', 'W: relative', 'U: blade speed'}, ...
                'Orientation', 'horizontal', ...
                'NumColumns', 3, ...
                'FontSize', 9);

            lgd.Layout.Tile = 'south';
        end
    end
end

linkaxes(plotAxes(:), 'xy');

%% Nested functions

    function XY = placeProfile(Q, chord, angleDeg, leadingEdge)

        R = [cosd(angleDeg), -sind(angleDeg); ...
            sind(angleDeg),  cosd(angleDeg)];

        XY = (chord * Q) * R.' + leadingEdge;
    end

    function XY = matchedProfile(Q, chord, angleDeg, leadingEdge, flow)
        % Replace camber with a cubic matching inlet/outlet flow angles.
        % Retain original offsets from the original camber line.
        % Assumes an ordered TE -> LE -> TE normalized profile.

        [~, iLE] = min(Q(:, 1));

        surface1 = Q(1:iLE, :);
        surface2 = Q(iLE:end, :);

        [x1, i1] = unique(surface1(:, 1));
        [x2, i2] = unique(surface2(:, 1));

        x = Q(:, 1);

        y1 = interp1(x1, surface1(i1, 2), ...
            x, 'linear', 'extrap');

        y2 = interp1(x2, surface2(i2, 2), ...
            x, 'linear', 'extrap');

        originalCamber = 0.5 * (y1 + y2);
        profileOffset = Q(:, 2) - originalCamber;

        flowAngles = atan2d(flow(:, 2), flow(:, 1));
        slopes = tand(flowAngles - angleDeg);

        % Zero camber displacement at both chord endpoints.
        newCamber = ...
            slopes(1) * (x.^3 - 2*x.^2 + x) + ...
            slopes(2) * (x.^3 - x.^2);

        shapedProfile = [x, newCamber + profileOffset];

        XY = placeProfile( ...
            shapedProfile, chord, angleDeg, leadingEdge);
    end

    function h = drawArrows(ax, arrows, color)

        h = quiver(ax, ...
            arrows(:, 1), arrows(:, 2), ...
            arrows(:, 3), arrows(:, 4), 0, ...
            'Color', color, ...
            'LineWidth', 1.6, ...
            'MaxHeadSize', 0.45);
    end
end