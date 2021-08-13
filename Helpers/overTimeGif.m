function topvalues = overTimeGif(t,vars,type,ttext,n,gifname)
% Visualize in an animation and save as .gif (optionally)

arguments
    t timetable
    vars string
    type string = "bar"
    ttext string = "Covid-19 Cases by Location"
    n double = 10
    gifname string = "no"
end

% Calculate by timestamp
t= sortrows(t);
alldates = unique(t.date);
alldates.Format = 'MMM dd, yyyy';

%% Display top 10 in bar plot over time

if type == "bar"
    figure
    a = axes;
    for ii = 1:length(alldates)
        % get top 10 states that day and values
        todaysvalue = t(t.date == alldates(ii),...
            :);
        % use function for top results
        topvalues = topkLocations(todaysvalue,n,vars,true,a);
        title([ttext,string(alldates(ii))])
        xlabel("Cases")
        ylabel("Location")
        drawnow;
        
        % assign color for each state
        % j = jet(55);
        % statecolormap = table;
        % statecolormap.states = string(categories(usstates.state));
        % statecolormap.statecolor = j;
        
        % Color by something
        
        % % save as gif
        if gifname ~= "no"
            appendAsGif(gifname,ii)
            pause(0.1)
        end
    end
    
elseif type == "map"
    figure
    gax = geoaxes;
    title(gax,ttext)
    for ii = 1:length(alldates)
        todaysvalue = t(t.date == alldates(ii),...
            :);
        % use function for results on map
        mapGif(todaysvalue,vars,gax)
        title(gax,[ttext,...
            string(alldates(ii))])
        geolimits(gax,[16.0 55.0],[-127.8 -66.5])
        if any(vars == "MaskRating")
            % update colorbar levels
            colormap(parula(5))
            cb = colorbar(gax,"Ticks",1:5,"Limits",[1 5]);
            %             cb.Limits = [1 5];
            % ticklenth
            cb.Label.String = "Mask Rating";
        else
            colorbar
        end
%         title(ttext)
        title(gax,[ttext,string(alldates(ii))])
        drawnow;
        
        % % save as gif
        if gifname ~= "no"
            appendAsGif(gax,gifname,ii)
            pause(0.1)
        end
    end
    topvalues = todaysvalue;
    
end

end

function appendAsGif(gax,gifname,ii)
% Write to gif
frame = getframe(gax); %1);
im = frame2im(frame);
[imind,cm] = rgb2ind(im,256);
if ii == 1
    imwrite(imind,cm,gifname,'gif','DelayTime',.1,'loopcount',inf);
else
    imwrite(imind,cm,gifname,'gif','DelayTime',.1,'writemode','append');
end

end

function mapGif(t,vars,gax)
% v1 area v2 color
r = rescale(t.(vars(1)),5,250);
if length(vars) > 1
    geoscatter(gax,t.LAT,t.LON,r,t.(vars(2)),"filled",...
        "MarkerFaceAlpha",0.4);
else
    geoscatter(t.LAT,t.LON,r,"filled",...
        "MarkerFaceAlpha",0.4);
end

% colorbar
end



