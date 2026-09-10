
function data = dataImport(profile)
%dataImport Imports current cycle data from GasTurb off design missions
%
%   data = dataImport(profile) Imports current cycle data from GasTurb 
%   off design missions and saves it as a MATLAB table
%
%   Input:
%       profile       - Profile (1-3)
%
%   Outputs:
%       data          - Table with labeled columns and rows
%
%   Profiles:
%       1     constraints.MSN
%       2     climbPhase.MSN
%       3     descentPhase.MSN
%
%   Example:
%       data = dataImport(1)
%       data{"Inner LPC Spec. Work", 'CRUISE'}
%
%   Notes
%   Use parantheses to keep indexing in table format, otherwise use curly
%   brackets to convert to an array as seen in example
%
%   You may use number indexing insted of variable name indexing
%

if profile == 1 %constraints
    t = readtable("..\Data\GasTurb\constraintPerformanceData.xlsx",'ReadRowNames',true);

elseif profile == 2 %climbPhase
    % t = readtable("..\Data\GasTurb\constraintPerformanceData.xlsx",'ReadRowNames',true);
    error('Profile not defined yet');

elseif profile == 3 %descentPhase
    % t = readtable("..\Data\GasTurb\constraintPerformanceData.xlsx",'ReadRowNames',true);
    error('Profile not defined yet');

else
    error('Invalid input! Input must be a profile number 1 through 3. See documentation (F1).');
end

t.Properties.VariableNames(1)={'Units'};
data = t;
end