<a name="back_to_top"></a>
# Quantifying and Exploring Flight Delay Trends in the U.S. Airline Industry

In this repository, we provide an overview of the MATLAB script utilized to:
1) Compute the flight delay matrices featured in our work: P (probability), D (delay), E (expected delay) and S (stationary distribution).
2) Modify the code to obtain route-specific flight delay information.

## MATLAB Code

### Table of Contents

1. [ Importing the Datasets ](#importing)
2. [ Building the Flight Delay Matrices ](#building)
3. [ Conducting the Delay Analysis ](#conducting)
4. [ Markov Chain Computations ](#markov)
5. [ Querying Route-specific Data ](#querying)
6. [ Additional Plots ](#additional)
7. [ Storing the Data ](#storing)

---
<a name="importing"></a>
### Importing the Datasets

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
### Building the Flight Delay Matrices 

**Description:** In this section, the P (probability), D (delay), and E (expected delay) matrices are constructed. Each of these three matrix types will come in three varieties: day of the week (i.e., D_day), airline carrier (i.e., D_airline), and aircraft type (i.e., D_airplane). The explanation for each type of matrix follows below:

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

**Lines of Code:** Lines 30 - 168.

([ back to top ](#back_to_top))

---
<a name="conducting"></a>
### Conducting the Delay Analysis

**Description:** In this section

**Lines of Code:** Lines 169 - 231.

([ back to top ](#back_to_top))

---
<a name="markov"></a>
### Markov Chain Computations

**Description:** In this section

**User Action:** Simply click on _Run Section_.

**Lines of Code:** Lines 232 - 290.

([ back to top ](#back_to_top))

---
<a name="querying"></a>
### Querying Route-specific Data

**Description:** In this section

**User Action:** Simply click on _Run Section_.

**Lines of Code:** Lines 291 - 409.

([ back to top ](#back_to_top))

---
<a name="additional"></a>
### Additional Plots

**Description:** In this section

**User Action:** Simply click on _Run Section_.

**Lines of Code:** Lines 410 - 451.

([ back to top ](#back_to_top))

---
<a name="storing"></a>
### Storing the Data

**Description:** In this section, the user can elect to export the D, P, E and S matrices as .csv files, according to the conducted analysis. The default matrices correspond to the average flight delay values, irrespective of day of the week, aircraft type or airline carrier. To export by:
* Day of the week: modify the index i on  ```D_day(:,:,i), P_day(:,:,i,1), and E_day(:,:,i)```.
* Aircraft Type: modify the index i on D_airplane(:,:,i), P_airplane(:,:,i,1), and E_airplane(:,:,i).
* Airline Carrier: modify the index i on D_airline(:,:,i), P_airline(:,:,i,1), and E_airline(:,:,i).

**User Action:** Modify the following code (lines 468 - 471) according to the user preferences:

  ```
  writematrix(D_day(:,:,8),'Average D.csv');
  writematrix(P_day(:,:,8,1),'Average P.csv');
  writematrix(E_day(:,:,8),'Average E.csv');
  writematrix(Markov,'Markov.csv');
  ```

 Then, simply click on _Run Section_. These .csv files will be saved in the same path as the MATLAB code itself.

**Lines of Code:** Lines 452 - 472.

([ back to top ](#back_to_top))

## Authors

Andy Eskenazi, Marek Homola, Olivier Ng'weno Kigotho <br />
Department of Aeronautics and Astronautics <br />
Massachusetts Institute of Technology, 2024 <br />
