<a name="back_to_top"></a>
# Visualizing and Quantifying Flight Delay Trends in the U.S. Airline Industry

In this repository, we provide an overview of the MATLAB (sections 1-6) script utilized to:
1) Compute the flight delay matrices featured in our work: P (probability), D (delay), E (expected delay), S (Markov transition) and S<sup>n</sup> (stationary distribution).
2) Modify the code to obtain route-specific flight delay information.

Additionally, this repository also provides guidance on how to use and modify the Python (section 7) script utilized to:

3) Calculate route delays based on sequences of flights.

## MATLAB Code

### Table of Contents

1. [ Importing the Datasets ](#importing)
2. [ Building the Flight Delay Matrices ](#building)
3. [ Markov Chain Computations ](#markov)
4. [ Querying Route-specific Data ](#querying)
5. [ Additional Plots ](#additional)
6. [ Storing the Data ](#storing)
7. [ Sequence of Flights Delays ](#sequence)

---
<a name="importing"></a>
### 1: Importing the Datasets

**Description:** In this section of the code, the two datasets utilized in this work are imported. These are:
* 'Delay Data.xlsx' (the version utilized in this work can be found on this [online](https://mitprod-my.sharepoint.com/:f:/g/personal/andyeske_mit_edu/El17ZquVEvNIqZzj7RC4w_QBmxD9QLxfptm6CgCZwRF65Q?e=T1Ckal) folder). This datatable contained information about every flight operated in the United States during January of 2023. 
* 'Tail Number.xlsm' (the version utilized in this work can be found on the [MATLAB Code](https://github.com/andyeske/Flight-delays/tree/main/MATLAB%20Code) folder). This datatable contained information about every tail-number in the US, with the corresponding aircraft type, upto 2022.

Both data sources were extracted from data made publicly available by the United States Bureau of Transportation Statistics. To obtain data corresponding to other months or years:
* Flight Delay data: to go the BTS Marketing Carrier [On-Time Performance](https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGK&QO_fu146_anzr=b0-gvzr). 
* Tail Number data: go to the BTS Air Carrier Financial [Schedule P-43 Inventory](https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=GEH&QO_fu146_anzr=Nv4%20Pn44vr4%20Sv0n0pvny).

**User Action:** Download the MATLAB script (which can be found [here](https://github.com/andyeske/Flight-delays/tree/main/MATLAB%20Code)), the two datatables listed above, and save everything in the same folder. Once in the MATLAB environment, simply click on _Run Section_.

**Lines of Code:** Lines 14 - 29.

([ back to top ](#back_to_top))

---
<a name="building"></a>
### 2: Building the Flight Delay Matrices 

**Description:** In this section, the P (probability), D (delay), and E (expected delay) matrices are constructed. Each of these three matrix types will come in three varieties: day of the week (i.e., ```D_day```), airline carrier (i.e., ```D_airline```), and aircraft type (i.e., ```D_airplane```). The explanation for each type of matrix follows below:

  ```
  - D_day: Average delay on each route, indexed by the day of the week. The 
    dimension of D_day is 333x339x8, since there are 339 airports in 
    the network. The 3rd dimension denotes the day of the week.
    Hence, in D(:,:,i), i = 1 is a Monday, i = 7 is a Sunday, while i = 8 
    refers to the total average.
    The rows of D_day represent the origin airport (OA), while the columns
    denote the destination airport (DA).
  - D_airline: Average delay on each route, indexed by airline (18 different     
    carriers considered in this work).
  - D_airplane: Average delay on each route, indexed by airplane type (41 
    different types considered in this work).
  ```

**User Action:** Simply click on _Run Section_.

**Lines of Code:** Lines 30 - 231.

([ back to top ](#back_to_top))

---
<a name="markov"></a>
### 3: Markov Chain Computations

**Description:** In this section, the Markov chain computations are conducted to obtain a stationary distribution for expected arrival flight delays in the U.S. airline route network. These calculations exploit a thought experiment, in which a passenger embarks itself in an infinite random walk across the airline network, starting at airport A, taking an infinite number of flights (each with an associated delay probability), and eventually ending at airport B. As the results elucidate, what matters is not the destination airport B, but the origin airport A (indeed, all the columns of the stationary matrix S, which correspond to the destination airports, will be identical). The description of utilized Markov _transition matrix_ to obtain the stationary distribution follows below:

  ```
  The rows of this matrix represent the origin airports, while the columns represent the destination. In 
  essence, the elements in each of the columns add up to 1, and the elements themselves represent the  
  number of flights out of airport i heading to airport j that are delayed, divided by the total number 
  of flights that are delayed heading into airport j. In essence, this matrix contains the answer to the 
  following question: out of all delayed flights arriving at airport j, what percentage correspond to 
  those coming from airport i?
  ```

The results from taking the 20th power of the Markov transition probility matrix can be seen in the plot below: 

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/Infinite%20Walks.jpg" width="500"> 

**Figure 1:** _Stationary Distribution Results_.
</p>

According to this plot, in the infinite random walks thought experiment, a passenger leaving out of Denver, irrespective of where it will ultimately end its journey, would be the most likely to be delayed, followed by Atlanta, Chicago, Dallas and Las Vegas.

**User Action:** Simply click on _Run Section_. However, it is possible to modify the code in this section (lines 244 - 246) to obtain the stationary distribution results using data specific to a day of the week, airline or aircraft type. 

**Lines of Code:** Lines 232 - 290.

([ back to top ](#back_to_top))

---
<a name="querying"></a>
### 4: Querying Route-specific Data

**Description:** In this section, the user selects a particular route using the standard IATA airport three letter codes (e.g., SFO - HNL) and a day of the week, and the code returns a plot displaying the route-specific flight delay statistics. In the case where the selected route does not exist in the U.S. airline route network, the code would display ```Selected route does not exist in the database```. A sample plot is shown below: 

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/Route%20Example.jpg" width="500"> 

**Figure 2:** _Route-specific flight delay statistics, corresponding to SFO - HNL_.
</p>

Here, the top most plot displays three bars, for the selected day of week, average weekday, and airport average expected arrival delays; the middle plot presents the arrival delays on the route, by operating airline; the bottom plots shows the aircraft-specific data for the route. The left y-axis describes the expected arrival flight delay, while the right y-axis denotes the probability that the would be delayed. The results are specific to January 2019 data.

**User Action:** To obtain custom route-specific flight delay statistics, modify the following code (lines 294, 296 and 298) according to the user preferences:

  ```
  Origin = 'SFO';
  ```
  ```
  Destination = 'HNL';
  ```
  ```
  Day = 'Friday';
  ```

Then, simply click on _Run Section_.

**Lines of Code:** Lines 291 - 409.

([ back to top ](#back_to_top))

---
<a name="additional"></a>
### 5: Additional Plots

**Description:** In this section, two additional plots are generated, corresponding to the network average delays disaggregated by airline and aircraft type. It is possible to modify the code in [ Section 2 ](#building) to display these results according to a particular day of the week, as opposed to the average. The following two plots are generated: 

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/Delay%20by%20Airline.jpg" width="500"> 

**Figure 3:** _Delay by Airline Carrier_.
</p>

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/Delay%20by%20Aircraft.jpg" width="500"> 

**Figure 4:** _Delay by Aircraft Type_.
</p>

Here, the left y-axis describes the expected arrival flight delay associated with flying on a particular airline carrier and/or aircraft type, while the right y-axis denotes the probability that a flight on a given airline and/or aircraft would be delayed. The results are specific to January 2019 data.

**User Action:** Simply click on _Run Section_.

**Lines of Code:** Lines 410 - 451.

([ back to top ](#back_to_top))

---
<a name="storing"></a>
### 6: Storing the Data

**Description:** In this section, the user can elect to export the D, P, E and S matrices as .csv files, according to the conducted analysis. The default matrices correspond to the average flight delay values, irrespective of day of the week, aircraft type or airline carrier. To export by:
* Day of the week: modify the index i on  ```D_day(:,:,i), P_day(:,:,i,1), E_day(:,:,i)```.
* Aircraft Type: modify the index i on  ```D_airplane(:,:,i), P_airplane(:,:,i,1), E_airplane(:,:,i)```.
* Airline Carrier: modify the index i on  ```D_airline(:,:,i), P_airline(:,:,i,1), E_airline(:,:,i)```.

**User Action:** To export custom datasets, modify the following code (lines 468 - 471) according to the user preferences:

  ```
  writematrix(D_day(:,:,8),'Average D.csv');
  writematrix(P_day(:,:,8,1),'Average P.csv');
  writematrix(E_day(:,:,8),'Average E.csv');
  writematrix(Markov,'Markov.csv');
  ```

Then, simply click on _Run Section_. These .csv files will be saved in the same path as the MATLAB code itself.

**Lines of Code:** Lines 452 - 472.

([ back to top ](#back_to_top))

---
<a name="sequence"></a>
### 7: Sequence of Flights Delays

**Description:** In this section, the user can run a Monte Carlo simulation of an aircraft flying a route that includes multiple airports to examine how the delay propagates through the route. 
The simulation uses a Bayesian probalistic Graphical Model (PGM) where each node is a Student's _t_-distributed random variable calibrated to fit the US BTS data.
Notice that this code requires [jupyter](https://jupyter.org/install) to be installed on your machine if it isn't already. 

**User Action:** Create a conda environment and build the dependencies in `Python\ Code/environment.yml` by navigating to the directory `Python\ Code` and running `conda env create -f environment.yml`.
If you haven't downloaded conda, follow these instuctions [here](https://conda.io/projects/conda/en/latest/user-guide/install/index.html). Next, run the following command to add the environment to jupyter notebook `python -m ipykernel install --user --name=myenv --display-name "Python (monte_carlo)"`

Run the jupyter notebook located in `Python\ Code/final_project.ipynb` by typing `jupyter notebook` in your terminal then navigating to `Python\ Code/final_project.ipynb`.
Enter the route you want to simulate in the section *Simulatate a flight trajectory using a Monte Carlo Simulation* and changed the variable named `path` in the cell below the title.
You can create a route of whatever number of stops you would like. In addition, you can modify the number of runs in the simulation by changing the variable `no_runs`.

The output should be the following three figures:

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/airports.png" width="500"> 

**Figure 5:** _Mean change in the delay time at certain airports. The time corresponds to the mean difference between the arrival delay and the departure delay of an aircraft passing through an airport for airports with a statistically significant number of samples (p-value less than 0.05_.
</p>

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/routes.png" width="500"> 

**Figure 6:** _Mean change in the delay time on certain routes. The time corresponds to the mean difference between the departure delay and the arriva delay for routes with a statistically significant number of samples (p-value less than 0.05)_.
</p>

<p align="left">
<img src="https://github.com/andyeske/Flight-delays/blob/main/Sample%20Plots/path.png" width="500"> 

**Figure 7:** _Flights flying from BOS to JFK then to MIA. The top plot shows the distribution of arrival times in MIA if the flight leaves on-time from BOS. The bottom distribution has an unknown departure time from BOS_.
</p>

## Authors

Andy Eskenazi, Marek Homola, Olivier Ng'weno Kigotho <br />
Department of Aeronautics and Astronautics <br />
Massachusetts Institute of Technology, 2024 <br />
