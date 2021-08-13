function predData = predictCases(model,data,numdays,newmaskrtgs)
% PREDICTCASES Predict number of covid-19 cases for given location
%

% Example: Predict cases, using abbreviation and new mask ratings.
% cty = "Providence";
% st = "RI";
% numdays = 60;__+
% newmaskratings = 0.5*ones(1,5);
% [predcases,testData,thiscounty] = predictCases(model,cty,st,numdays,newmaskratings);


% Check inputs and set defaults
arguments
    model (1,1) %RegressionGP
%     cty string
%     st string
    data tabular
    numdays double = 7
    newmaskrtgs double = []
%     a matlab.graphics.axis.Axes = axes
    
end
% 
%% 
% Prep data
dname = data.Properties.DimensionNames;
if dname{1} == "dates"
%     dname{1} = "date";
    data.Properties.DimensionNames{1} = 'date';
end

mskvars = ["NEVER","RARELY","SOMETIMES","FREQUENTLY","ALWAYS"];
vars = ["date","dayvalue","cases","POPESTIMATE2019","LON","LAT",... 
    mskvars]; 

% 
%% Predict for this data
if istimetable(data)
    data = timetable2table(data);
end

%% Update time (since 2020)
day1 = datetime(2020,1,1);


% if 

data.dayvalue = data.date - day1;
data.dayvalue = days(data.dayvalue);

% get just the values of interest
% vars = ["dayvalue","POPESTIMATE2019","LON","LAT",... 
%     "NEVER","RARELY","SOMETIMES","FREQUENTLY","ALWAYS"]; 
tData = data(:,vars);

%% Prep future time/ mask values
% Add date info to testData for future
% repeat the data if a vector
ndays = 0:numdays-1;

if length(ndays) > 1
    testData1 = repmat(tData(1,:),[numdays 1]);
else
    testData1 = tData(1,:);
end
t = datetime("now")+caldays(ndays)';
% testData1.dates = t;
testData1.date = t;
testData1.cases = NaN(size(t));
testData1.dayvalue = floor(days(t - day1));
testData = [tData;testData1];


% Replace mask usage if passed to function
if ~isempty(newmaskrtgs)
    x = repmat(newmaskrtgs,[height(testData) 1]);
    testData{:,mskvars} = x;    
end

%% Make predictions
predcases = predict(model,testData);
testData.predcases = predcases;

predData = testData(:,["date","predcases"]);

if dname{1} == "dates"  % pass back the way it was passed in
    predData = renamevars(predData,"date","dates");
end

%% Visualize
% if doPlot
% if isempty(a)
%     figure
%     a = axes;    
% end
% tf = [data.date;t];
% 
% plot(a,data.date,data.cases,'.')
% hold on
% plot(a,tf,predcases,".")
% xline(a,datetime("now"),"--","Today","LabelVerticalAlignment","bottom")
% % hold off
% legend(a,"Historical","Predicted","Today","Location","northwest")
% title(a,["Cases for "+cty+" County, "+st,...
%     "Predicted: "+string(floor(predcases(end)))])


% end
