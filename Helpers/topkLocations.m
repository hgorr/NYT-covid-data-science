function [topcounts,b] = topkLocations(t,n,vars,plotflag,a,direction)
%TOPKLOCATIONS Return results of topkrows and create a bar plot

if nargin < 6
    direction = "descend";
end
if nargin < 5
    a = []; % axes
end
if nargin < 4
    plotflag = true;
end

% Determine top locations
topcounts = topkrows(t,n,vars,direction);
varnames = topcounts.Properties.VariableNames;

if any(varnames == "county")
    topcounts.loc = string(topcounts.county) + ", " + ...
        string(topcounts.state);
else
    topcounts.loc = string(topcounts.state);
end

% Plot
if plotflag
    if ~isempty(a)
        b = barh(a,flipud(topcounts.(vars(1))));
    else
        b = barh(flipud(topcounts.(vars(1))));
    end
    yticks(1:length(topcounts.loc))
    yticklabels(flipud(topcounts.loc))
end


end

