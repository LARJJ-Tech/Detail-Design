
function data = dataImport(profilePath)
%dataImport Imports current cycle data from GasTurb off design missions
%
%   data = dataImport(profile) Imports current cycle data from GasTurb 
%   off design missions and saves it as a MATLAB table
%
%   Input:
%       profilePath       - Path to profile
%
%   Outputs:
%       data              - Table with labeled columns and rows
%
%   Example:
%       data = dataImport("..\Data\GasTurb\constraintPerformanceData.xlsx")
%       data{"Inner LPC Spec. Work", 'CRUISE'}
%
%   Notes
%   Use parantheses to keep indexing in table format, otherwise use curly
%   brackets to convert to an array as seen in example
%
%   You may use number indexing insted of variable name indexing
%

t = readtable(profilePath,'ReadRowNames',true);
t.Properties.VariableNames(1)={'Units'};
data = t;
end