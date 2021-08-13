% function 

load allCountyData
% allCountyData1 = allCountyData(:,1:3);
% allCountyData1.abbrev = allCountyData.abbrev;

%% get rid of unnecessary vars
% countyMasks = removevars(countyMasks,{'DEATHS2019','MaskRating'}%{'fips_COUNTYFP','cases','deaths','DEATHS2019','casesbypop','deathsbypop','MaskRating'});
% countyMasks = removevars(countyMasks, 'state');

allCountyData = removevars(allCountyData, 'state');
allCountyData = removevars(allCountyData, 'deaths');
allCountyData = removevars(allCountyData, {'DEATHS2019','casesbypop','deathsbypop'});
allCountyData = removevars(allCountyData, 'MaskRating');

%% 
t = timetable2table(allCountyData); %(:,4:end));
% day1 = datetime(2020,1,1);
% t.dayvalue = days(t.date - day1);
% t.date = [];
% whos t allCountyData allCountyCases countyMasks
% totalcases = groupsummary(t,["county","abbrev"],@lastValueCalc,"cases");
casevec = groupsummary(t,["county","abbrev"],@(x) {x},"cases");
mintime = groupsummary(t,["county","abbrev"],"min","date");
%%
% add date, totes
casevec.min_date = mintime.min_date;
% casevec.totalcases = totalcases.fun1_cases;
casevec = removevars(casevec,'GroupCount');
casevec = renamevars(casevec,'fun1_cases','cases');

%% join w/ other data

joinedData = outerjoin(countyMasks,casevec,'Type','left','Keys',{'county',...
    'abbrev'},'MergeKeys',true);
% joinedData = removevars(joinedData,'GroupCount');
% head(joinedData,5)

%% save new variable w/ all info
joinedData = renamevars(joinedData,"cases_countyMasks","totalcases");
joinedData = renamevars(joinedData,"cases_casevec","cases");
%%
countyMasks = joinedData;
% save countyMasks2 countyMasks

%% expand in predict function (prep data)
% only pass times of interest and one row from countyMasks (info) pop, lat,
% lon, mask uages
% predictCases(mdl,mycty,maskvals,[t0 tf]);



%% other 
% dont need as much data - repeated in mat files , remove what we dont need
% compact models
% linear model only in git

