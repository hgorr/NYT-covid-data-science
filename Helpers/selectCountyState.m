function data = selectCountyState(data,county,state)
% load allCountyData.mat allCountyData


if nargin < 3
   state = "";   
end
%%
% extract the data
maskvarnames = ["NEVER","RARELY","SOMETIMES",...
        "FREQUENTLY","ALWAYS"];
vars = ["min_date","county","abbrev","cases",... 
     "LON","LAT","POPESTIMATE2019",maskvarnames];

% check length of state (string length)
if strlength(state) == 0
    mycty = data(data.county == county,vars);
elseif strlength(state) == 2
    mycty = data(data.county == county & ...
        data.abbrev == state,vars);
end
% else
%      mycty = data(data.county == county & ...
%         data.state == state,vars);    
% end

%% arrange for app/ machine learning
    if ~istimetable(mycty)
        mycty = table2timetable(mycty);
    end
    
    cases = mycty.cases{1};
    tt = timetable(cases,'TimeStep',caldays(1),'StartTime',mycty.min_date);
    
    %% Expand county info to timestamps to plot, predict
    idx = string(mycty.Properties.VariableNames) ~= "cases"; % exclude cases since above
    data = synchronize(tt,mycty(:,idx),"first",'previous');
    data.Properties.DimensionNames{1} = 'dates';
    

%% error 
if isempty(mycty)
    errordlg("Error occured finding location data. Try entering county, state again")
end

% select county
% get data from table


