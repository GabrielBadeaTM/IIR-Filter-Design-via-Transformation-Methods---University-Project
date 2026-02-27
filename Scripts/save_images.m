clc; clear;

% Folderul Downloads
if ispc
    downloadsFolder = fullfile(getenv('USERPROFILE'), 'Downloads');
else
    downloadsFolder = fullfile(getenv('HOME'), 'Downloads');
end

% Găsim toate figurile deschise
figHandles = findall(0, 'Type', 'figure');

for i = 1:numel(figHandles)
    hFig = figHandles(i);
    
    filename = fullfile(downloadsFolder, sprintf('Figura_%d.png', hFig.Number));
    exportgraphics(hFig, filename, 'Resolution', 600);
    
    fprintf('Salvat: %s\n', filename);
end
fprintf('Gata!\n');