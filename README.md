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

**Lines of Code:** Lines 14 - 29.



