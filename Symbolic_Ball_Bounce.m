%% Ball Bounce Project
% Code By: Brandon Ching
% Group: Ben Bartlett, Sarah Ford, James Dornblaser
clc; clear; close all;

%% Initial Setup
E = 0.894153; % COR of ball/plate
h = 0.548; % height at which ball is droped from above impact point
obj_x = 0.456; %x length of the object placement from impact
obj_y = 0.062; %y height of the object placement from impact
g = 9.81; % g, gravity, m/s^2
y0 = 0; % y, initial vertical position, m
x0 = 0; % x, initial horizontal position, m
alpha = 0:0.01:90; %vary the plate angle from flat to vertical

%% Determine whether or not the ball will clear the obstacle
v_2 = (E .* cosd(alpha) * sqrt(2*g*h)) ./ (sind(atand(E*cotd(alpha)))); % v, initial velocity
angle = atand(E*cotd(alpha)) - alpha; % angle, launch angle
y_clear = -((g*obj_x^2) ./ (2 * v_2.^2 .* cosd(angle).^2)) + (obj_x .* tand(angle));
cleared = y_clear > obj_y;

figure % New figure
plot(alpha, y_clear, 'r', 'LineWidth' , 2); hold on;
plot(alpha(cleared),y_clear(cleared), 'g', 'LineWidth' , 2); hold off;
xlabel("Plate Angle (deg)")
ylabel("Vertical Clearance Above Obstacle (m)")
title("Affect of Angle on Clearance Above Obstacle")
legend('Does not Clear Obstacle','Clears Obstacle');
axis([0 90 -0.5 0.5])

%% Solve for the Max Height of the Ball's Trajectory
h_max = (v_2.^2 .* sind(angle).^2) ./ (2*g);

figure % New figure
plot(alpha, h_max, 'r', 'LineWidth' , 2); hold on;
plot(alpha(y_clear > obj_y),h_max(y_clear > obj_y), 'g', 'LineWidth' , 2); hold off;
xlabel("Plate Angle (deg)")
ylabel("Max Height (m)")
title("Max Height of Ball Durring Bounce")
legend('Does not Clear Obstacle','Clears Obstacle','Location', 'NW');

%% Plot Best Path and acutal
best_alpha = min(alpha(logical(cleared)));
best_angle = angle(find(alpha==best_alpha));
best_v_2 = v_2(find(alpha==best_alpha));
t_f = (2 * best_v_2 * sind(best_angle))/g;
t = linspace(0,t_f,1000);
x = best_v_2 * cosd(best_angle) * t;
y = -((1/2) * (g * t.^2)) + (best_v_2 .* sind(best_angle) .* t);

x_act = [0 0.02514 0.0565 0.08277 0.113 0.142 0.180 0.203 0.233 0.262 0.294 0.322 0.352 0.379 0.402 0.43 0.45 0.472 0.490];
y_act = [0 0.07294 0.166 0.23 0.29 0.34 0.383 0.401 0.412 0.412 0.4 0.372 0.334 0.285 0.234 0.165 0.111 0.0229 -0.05723];

figure % New figure
plot(x, y, 'g', 'LineWidth' , 2); hold on;
plot(x_act, y_act, 'b--', 'LineWidth' , 2); hold on;
plot(obj_x,obj_y, 'b.', 'MarkerSize', 30); hold off;
xlabel("Vertical Distace (m)")
ylabel("Horizontal Distance(m)")
title("Simulated vs Actual Ball Trajectory of Aluminium Plate and Nylon Ball")
legend('Predicted Trajectory','Actual Trajectory', 'Obstacle', 'Location', 'NW');
axis([0 0.5 0 0.5])

%% Print out a summary of the data
fprintf("With a COR of e=%f, this plate/ball combination can clear an obstacle %.3fm away and %.3fm high when the plate angle is between %.2f-%.2f degrees.\n",E,obj_x,obj_y, min(alpha(logical(cleared))), max(alpha(logical(cleared))))
fprintf("The best angle to clear the obstacle & maximize height is %.2f degrees with a height of %fm.\n", best_alpha, max(h_max(logical(cleared))))