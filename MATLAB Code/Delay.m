%% Delay Analysis - Code Description (MATLAB)
% The following code serves as a complement to the main paper, and is used 
% to conduct the delay-related calculations.

% The following script is divided into 7 sections:
% 1: Importing the Required Datasets
% 2: Building the Flight Delay Matrices
% 3: Conducting the Delay Analysis
% 4: Markov Chain Computations
% 5: Querying Route-specific data
% 6: Additional Plots
% 7: Storing the Data

%% 1a: Delay Matrix

% Importing the flights delay dataset (downloaded from the BTS).
Delay_Data = readtable('Delay Data.xlsx');
% Here, the delay dataset corresponds to 538837 flights over the span of January
% 2023, corresponding to 15 different airlines. 

%% 1b: Aircraft Database

% Importing the tailnumber dataset (downloaded from the BTS).
N_Data = readtable('Tail Numbers.xlsm');
Aircraft = N_Data{2:42,10};
% Here, the tailnumber dataset corresponds to aircraft and tailnumber
% information for 7923 airplanes within the total US fleet, across 15
% different commercial airlines.

%% 2: Building the Delay Matrices

% Variables of Interest (columns in the Delay_Data matrix):
% Quarter: 2
% Month: 3
% Day of Week: 5
% Airline: 6
% Tail Number: 7
% Origin Airport Code: 11
% Origin Airport Number: 8
% Destination Airport Code: 15
% Destination Airport Number: 12
% Scheduled Departure Time: 16
% Actual Departure Time: 17
% Departure Delay: 19
% Scheduled Arrival Time: 25
% Actual Arrival Time: 26
% Arrival Delay: 28
% Distance: 33
% Unique Airports: 37 (1 - 339)
% Unique Airlines: 40 (1 - 15)

% Airport Indexing
Airports = Delay_Data{1:339,38};
Airport_Codes = Delay_Data{1:339,37};

% Airlines Indexing
Airlines = Delay_Data{1:15,41};
Airline_Codes = Delay_Data{1:15,40};

% Weekdays
Weekdays = {'Monday';'Tuesday';'Wednesday';'Thursday';'Friday';'Saturday';'Sunday'};

% Matrices
% - D_day: Average delay on each route, indexed by the day of the week. The 
%   dimension of M_day is 333x339x8, since there are 339 airports in 
%   the network. The 3rd dimension denotes the day of the week.
%   Hence, in D(:,:,i), i = 1 is a Monday, i = 7 is a Sunday, while i = 8 
%   refers to the total average.
%   The rows of D_day represent the origin airport (OA), while the columns
%   denote the destination airport (DA).
% - D_airline: Average delay on each route, indexed by airline.
% - D_airplane: Average delay on each route, indexed by airplane type.
% - P_day: Probability that the route will be delayed, indexed by day of 
%   the week. This is calculated by dividing the number of delayed flights 
%   on route ij over the total number of flights on route ij.
% - P_airline: Probability that the route will be delayed, indexed by
%   airline.
% - P_airplane: Probability that the route will be delayed, indexed by
%   airplane type
% - M_Airplanes: aircraft type-specific delay, for 41 different types. 
% - M_Airlines: airline-specific delay, for 18 different carriers. 

% Initializing the values of D_day, D_airline, P_day, P_airline, 
% M_Airplanes and M_Airlines matrices:
l = height(Delay_Data);
D_day = zeros(339,339,8);
P_day = zeros(339,339,8,2); % The 4th dimension of the P matrix refers to 
                            % i) counting the flights that were delayed
                            % ii) counting all the total number of flights
D_airline = zeros(339,339,15);
P_airline = zeros(339,339,15,2); 
D_airplane = zeros(339,339,41);
P_airplane = zeros(339,339,41,2); 
% Airport and Airline Specific Stats
M_Airplanes = zeros(41,5);
M_Airlines = zeros(15,5);

for k = 1:l
    
    d = Delay_Data{k,28};

    if isnan(d) == 0
        % Find the Origin Airport:
        OA = Delay_Data{k,8};
        oa = find(OA == Airports);
    
        % Find the Destination Airport:
        DA = Delay_Data{k,12};
        da = find(DA == Airports);
    
        % Find the Tail Number (TN):
        TN = Delay_Data{k,7};
        % Find the Aircraft-type correspoing to the TN
        at = find(strcmp(N_Data{:,1}, TN));
        if isempty(at)
            at_in = 1;
        else
            airplane = N_Data{at,5};
            % Find the index of the aircraft type
            at_in = find(strcmp(Aircraft, airplane));
        end

        % Find the Airline:
        air = Delay_Data{k,6};
        air_in = find(strcmp(air, Airline_Codes));

        % Find the Day of the Week:
        day = Delay_Data{k,5};

        % Populating the D_day matrix 
        D_day(oa,da,day) = D_day(oa,da,day) + d; % Day-specific
        D_day(oa,da,8) = D_day(oa,da,8) + d; % Total

        % Populating the D_airline matrix
        D_airline(oa,da,air_in) = D_airline(oa,da,air_in) + d; % Airline-specific

        % Populating the D_airline matrix
        D_airplane(oa,da,at_in) = D_airplane(oa,da,at_in) + d; % Aircraft-specific

        % Per-aircraft delay
        M_Airplanes(at_in,1) = M_Airplanes(at_in,1) + d;

        % Per-airline delay
        M_Airlines(air_in,1) = M_Airlines(air_in,1) + d;
    
        % Populating the P matrix
        if d ~= 0 % Adding only when the flight is actually delayed
            P_day(oa,da,day,1) =  P_day(oa,da,day,1) + 1;
            P_day(oa,da,8,1) =  P_day(oa,da,8,1) + 1;
            P_airline(oa,da,air_in,1) = P_airline(oa,da,air_in,1) + 1;
            P_airplane(oa,da,at_in,1) = P_airplane(oa,da,at_in,1) + 1;
            % Per-aircraft delays
            M_Airplanes(at_in,2) = M_Airplanes(at_in,2) + 1;
            % Per-airlines delays
            M_Airlines(air_in,2) =  M_Airlines(air_in,2) + 1;
        end
        % Counting the total number of flights
        P_day(oa,da,day,2) =  P_day(oa,da,day,2) + 1;
        P_day(oa,da,8,2) =  P_day(oa,da,8,2) + 1;
        P_airline(oa,da,air_in,2) = P_airline(oa,da,air_in,2) + 1;
        P_airplane(oa,da,at_in,2) = P_airplane(oa,da,at_in,2) + 1;
        M_Airplanes(at_in,3) = M_Airplanes(at_in,3) + 1;
        M_Airlines(air_in,3) =  M_Airlines(air_in,3) + 1;

    end

end

%% 3: Conducting the Delay Analysis

% Computing the average delay on each route 
% (total delay minutes/# of delayed flights)
% Per day of week:
D_day(:,:,:) = D_day(:,:,:)./P_day(:,:,:,1);
D_day(isnan(D_day)) = 0;
% Per airline:
D_airline(:,:,:) = D_airline(:,:,:)./P_airline(:,:,:,1);
D_airline(isnan(D_airline)) = 0;
% Per airplane:
D_airplane(:,:,:) = D_airplane(:,:,:)./P_airplane(:,:,:,1);
D_airplane(isnan(D_airplane)) = 0;

% Computing the probability of delay on each route
% (# of delayed flights/total # of flights)
% Per day of week:
P_day(:,:,:,1) = P_day(:,:,:,1)./P_day(:,:,:,2);
P_day(isnan(P_day)) = 0;
% Per airline:
P_airline(:,:,:,1) = P_airline(:,:,:,1)./P_airline(:,:,:,2);
P_airline(isnan(P_airline)) = 0;
% Per airplane:
P_airplane(:,:,:,1) = P_airplane(:,:,:,1)./P_airplane(:,:,:,2);
P_airplane(isnan(P_airplane)) = 0;

% Computing the expected delay on each route
% (average route delay * probability of delay)
% Per day of week:
E_day = D_day(:,:,:).*P_day(:,:,:,1);
E_day(isnan(E_day)) = 0;
% Per airline:
E_airline = D_airline(:,:,:).*P_airline(:,:,:,1);
E_airline(isnan(E_airline)) = 0;
% Per airplane:
E_airplane = D_airplane(:,:,:).*P_airplane(:,:,:,1);
E_airplane(isnan(E_airplane)) = 0;

% Average Expected Delay and Probability of Delay at each destination airport
arr_Delay = zeros(339,3);
for k = 1:339
    in = find(E_day(:,k,8) > 0);
    arr_Delay(k,1) = mean(E_day(in,k,8));
    arr_Delay(k,2) = sum(P_day(in,k,8,1).*P_day(in,k,8,2))/sum(P_day(in,k,8,2));
    arr_Delay(k,3) = sum(P_day(in,k,8,2));
end

% Aircraft Type Analysis
% Similarly to above, here, the average delay per aircraft type and
% probability of delay are calculated. The multiplication of these two
% quantities (on an aircraft-type basis) results in the expected delay.
M_Airplanes(:,4) = M_Airplanes(:,1)./M_Airplanes(:,2); % Average delay
M_Airplanes(:,5) = M_Airplanes(:,2)./M_Airplanes(:,3); % Probability of delay
M_Airplanes(isnan(M_Airplanes)) = 0;

% Aircraft Type Analysis
% In here, the average delay per airline and probability of delay are 
% calculated. The multiplication of these two quantities 
% (on an airline basis) results in the expected delay.
M_Airlines(:,4) = M_Airlines(:,1)./M_Airlines(:,2); % Average delay
M_Airlines(:,5) = M_Airlines(:,2)./M_Airlines(:,3); % Probability of delay
M_Airlines(isnan(M_Airlines)) = 0;

%% 4: Markov Chain Computations

% Computing the flight delays matrix out of an airport 
% Like before, the rows of this matrix represent the origin airports, while
% the columns represent the destination. In essence, the elements in each
% of the columns add up to 1, and the elements themselves represent the
% number of flights out of airport i heading to airport j that are delayed,
% divided by the total number of flights that are delayed heading into
% airport j. In essence, this computation seeks to answer the following
% question: out of all delayed flights arriving at airport j, what
% percentage correspond to those coming from airport i?
% (Here, only the system average data is used, so index 8 - i.e., day-independent).
Markov = P_day(:,:,8,1).*P_day(:,:,8,2);
total_delayed = sum(Markov,1);
Markov = Markov./total_delayed;

% Computing an Initial Random Distribution
v = rand(339,1);
v = v./sum(v);

% Computing the Stationary Distribution (for n = 20).
n = 20;
s = (Markov^n)*v;

% Markov Chain Explanation: JFK | MIA | BOS
% Car Problem: 
% * We rent a car in BOS, and we return it in MIA or JFK with some probability.
% * System: given that we rent a car, what is the probability that we will return it in BOS, MIA or JFK?

% Delay Problem: 
% * We take a flight in BOS, and it has a delay arriving to MIA or JFK with some probability.
% * System: given that we take a flight, what is the probability that there will be a delay arriving in BOS, MIA or JFK?

% Stationary distribution idea: given that we take any flight in the system, it tells us the probability that it will be delayed arriving to a specific airport.
% The idea of calculating the stationary distribution is associated with
% taking an infinite random walk. As the results elucidate, what matters is
% not the destination, but the origin airport of the random walk. Indeed, this
% will solely determine the probability of delay arriving at some airport.

% Plotting the Stationary Distribution (considering only the top 30
% airports)
figure
s_sorted = sort(s,'descend');
s_in = zeros(30,1);
for k = 1:30
    s_in(k) = find(s_sorted(k) == s);
end
x = categorical(Airport_Codes(s_in));
x = reordercats(x,Airport_Codes(s_in));
times = arr_Delay(s_in);
yyaxis left
bar(x,times,'FaceAlpha',.5)
xlabel('Origin Airport')
ylabel('Expected Arrival Delay (min)')
yyaxis right
plot(x,100*s_sorted(1:30),'--o','LineWidth',2)
ylabel('Probability of Arrival Delay (%)')
set(gca,'FontSize',12)

%% 5: Quering Route-specific data

% Inputting the route data
Origin = 'SFO';
oa = find(strcmp(Airport_Codes, Origin));
Destination = 'HNL';
da = find(strcmp(Airport_Codes, Destination));
Day = 'Friday';
day = find(strcmp(Day, Weekdays));

% Finding the airlines that operate on that route
a = find(E_airline(oa,da,:) ~= 0);
if isempty(a) % Checking if the route exists
    disp('Selected route does not exist in the database')
else
    expected_delay_airline = zeros(length(a),1);
    P_delay_airline = zeros(length(a),1);
    flight_airline = zeros(length(a),1);
    % Finding the number of flights operated by each airline on the
    % route:
    flight_airline(:,1) = P_airline(oa,da,a,2);
    
    % Finding the airplanes that operate on that route
    aero = find(E_airplane(oa,da,:) ~= 0);
    expected_delay_airplanes = zeros(length(aero),1);
    P_delay_airplanes = zeros(length(aero),1);
    flight_airplanes = zeros(length(aero),1);
    % Finding the number of flights operated by each airplane type on the
    % route:
    flight_airplanes(:,1) = P_airplane(oa,da,aero,2);

    % Computing the expected route delay
    expected_delay_by_day = E_day(oa,da,day);
    expected_delay_avg = E_day(oa,da,8);
    expected_delay_airline(:,1) = E_airline(oa,da,a);
    expected_delay_airplanes(:,1) = E_airplane(oa,da,aero);
    
    % Computing the route delay probability
    P_delay_by_day = P_day(oa,da,day,1);
    P_delay_avg = P_day(oa,da,8,1);
    P_delay_airline(:,1) = P_airline(oa,da,a,1);
    P_delay_airplanes(:,1) = P_airplane(oa,da,aero,1);
    
    % Computing the number of flights
    flights_day = P_day(oa,da,day,2);
    flights_total = P_day(oa,da,8,2);

    % Expected delay at the arrival airport
    aa = find(strcmp(Airport_Codes, Destination));
    expected_delay_arrival = arr_Delay(aa,1);
    P_delay_arrival = arr_Delay(aa,2);
    flights_arrival = arr_Delay(aa,3);
    
    % Plotting the route delay information
    expected_delay = [expected_delay_by_day;expected_delay_avg;expected_delay_arrival];
    P_delay = [P_delay_by_day;P_delay_avg;P_delay_arrival];
    flights = [flights_day;flights_total;flights_arrival];
    
    % Plot
    figure 
    T = tiledlayout(3,1);
    % Day of Week Analysis
    nexttile
    labels = {Day;'Route Average';[Destination,' Average']};
    x_delay = categorical(labels);
    x_delay  = reordercats(x_delay,labels);
    yyaxis left
    bar(x_delay,expected_delay,'FaceAlpha',.5);
    for k = 1:3
         t = text(k,expected_delay(k)+1,{['Flights: ',num2str(flights(k))]},'FontSize',12);
         t.Rotation = 90;
    end
    %ylabel('Expected Arrival Delay (min)')
    ylim([0 max(expected_delay)*1.4])
    title([Origin,' to ',Destination,' - January 2023'])
    %title({['Route: ',Origin,' to ',Destination],'January 2023'})
    yyaxis right
    plot(x_delay,100*P_delay,'--o','LineWidth',2)
    %ylabel('Probability of Delay (%)')
    set(gca,'FontSize',12)

    % Airline Analysis
    nexttile
    x_delay2 = categorical(Airlines(a));
    x_delay2  = reordercats(x_delay2,Airlines(a));
    yyaxis left
    bar(x_delay2,expected_delay_airline,'FaceAlpha',.5);
    for k = 1:length(a)
         t = text(k,expected_delay_airline(k)+1,{['Flights: ',num2str(flight_airline(k))]},'FontSize',12);
         t.Rotation = 90;
    end
    ylabel('Expected Arrival Delay (min)')
    ylim([0 max(expected_delay_airline)*1.4])
    yyaxis right
    plot(x_delay2,100*P_delay_airline,'--o','LineWidth',2)
    ylabel('Probability of Delay (%)')
    set(gca,'FontSize',12)

    % Aircraft Analysis
    nexttile
    x_delay3 = categorical(Aircraft(aero));
    x_delay3  = reordercats(x_delay3,Aircraft(aero));
    yyaxis left
    bar(x_delay3,expected_delay_airplanes,'FaceAlpha',.5);
    for k = 1:length(aero)
         t = text(k,expected_delay_airplanes(k)+1,{['Flights: ',num2str(flight_airplanes(k))]},'FontSize',12);
         t.Rotation = 90;
    end
    %ylabel('Expected Arrival Delay (min)')
    ylim([0 max(expected_delay_airplanes)*1.4])
    %title({['Route: ',Origin,' to ',Destination],'January 2023'})
    yyaxis right
    plot(x_delay3,100*P_delay_airplanes,'--o','LineWidth',2)
    %ylabel('Probability of Delay (%)')
    set(gca,'FontSize',12)
    T.TileSpacing = 'compact';
    T.Padding = 'compact';
end

%% 6: Additional Plotting 

% Aircraft Data Plot: finding the expected delays, by aircraft type
figure
expected = M_Airplanes(:,4).*M_Airplanes(:,5);
AA_sorted = sort(expected,'descend');
AA_in = zeros(32,1);
for k = 1:32
    AA_in(k,1) = find(AA_sorted(k) == expected);
end
x_air = categorical(Aircraft(AA_in));
x_air = reordercats(x_air,Aircraft(AA_in));
yyaxis left
bar(x_air,AA_sorted(1:32),'FaceAlpha',.5);
xlabel('Aircraft Type')
ylabel('Expected Arrival Delay (min)')
%title('P(Delay|Aircraft type) - Independent of Route')
yyaxis right
plot(x_air,100*M_Airplanes(AA_in,5),'--o','LineWidth',2)
ylabel('Probability of Arrival Delay (%)')
set(gca,'FontSize',12)

% Airline Data Plot: finding the expected delays, by airline
figure
expected = M_Airlines(:,4).*M_Airlines(:,5);
AA_sorted = sort(expected,'descend');
AA_in = zeros(15,1);
for k = 1:15
    AA_in(k,1) = find(AA_sorted(k) == expected);
end
x_air = categorical(Airlines(AA_in));
x_air = reordercats(x_air,Airlines(AA_in));
yyaxis left
bar(x_air,AA_sorted,'FaceAlpha',.5);
xlabel('Airline')
ylabel('Expected Arrival Delay (min)')
%title('P(Delay|Airline) - Independent of Route')
yyaxis right
plot(x_air,100*M_Airlines(AA_in,5),'--o','LineWidth',2)
ylabel('Probability of Arrival Delay (%)')
set(gca,'FontSize',12)

%% 7: Exporting the data into excel sheets

% Exporting the average D, E, P and Markov matrices
% (the code below can be modified to export any specific matrix, whether
% that is for any of the 41 aircraft types, 7 days of the week, or 15
% airlines).

% Notes:
% - The columns and rows correspond to the vector 'Airport_Codes'.
% - To export by a particular days of the week, these can be selected by 
% modifying the index i on D_day(:,:,i).
% - To export by aircraft types, these can be selected from the vector
% 'Aircraft', modifying the index i on D_aircraft(:,:,i).
% - To export by airline carriers, these can be selected from the vector
% 'Airlines', modifying the index i on D_airline(:,:,i).

writematrix(D_day(:,:,8),'Average D.csv');
writematrix(P_day(:,:,8,1),'Average P.csv');
writematrix(E_day(:,:,8),'Average E.csv');
writematrix(Markov,'Markov.csv');
