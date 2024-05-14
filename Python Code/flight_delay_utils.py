import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import ttest_1samp
from typing import Tuple
from scipy.stats import t


def sample_from_t(mean, std, n, size):
    if n > 1:  # Ensure there are enough samples to define a distribution
        df = n - 1  # Degrees of freedom
        scale = std / np.sqrt(n)  # Standard error of the mean
        return t.rvs(df, mean, scale, size=size)
    else:
        return np.nan  # Return NaN if not enough data points

def get_delays(df: pd.DataFrame, destinations, origins, confidence = 95, delay_type="ARR_DELAY"):
    overall_mean = df[delay_type].mean()
    overall_std = df[delay_type].std()

    df_filtered = df[df['DEST'].isin(destinations) & df['ORIGIN'].isin(origins)]
    mean_delays = pd.DataFrame(index=destinations, columns=origins)
    std_delays = pd.DataFrame(index=destinations, columns=origins)

    for (dest, origin), group in df_filtered.groupby(['DEST', 'ORIGIN']):
        data = group[delay_type].dropna()
        if len(data) > 1 and data.var() > 0:  # Ensure enough data points and non-zero variance
            _, pvalue = ttest_1samp(data, overall_mean)
            mean_delays.at[dest, origin] = data.mean() if pvalue < (100-confidence)/100 else overall_mean
            std_delays.at[dest, origin] = data.std() if pvalue < (100-confidence)/100 else overall_std
        else:
            mean_delays.at[dest, origin] = overall_mean
            std_delays.at[dest, origin] = overall_std
    return mean_delays.fillna(overall_mean), std_delays.fillna(overall_std) # fill nans with mean values


def get_delay_statistics(df, destinations, origins, confidence = 95):
    df['DELAY_DIFF'] = df['ARR_DELAY'] - df['DEP_DELAY']
    overall_std_diff = np.nanstd(df['DELAY_DIFF'])  # Use nanstd to ignore NaNs

    std_delay_diff = pd.DataFrame(index=destinations, columns=origins)
    for (dest, origin), group in df[(df['DEST'].isin(destinations)) & (df['ORIGIN'].isin(origins))].groupby(['DEST', 'ORIGIN']):
        data = group['DELAY_DIFF'].dropna()
        if len(data) > 1 and data.var() > 0:  # Check for sufficient data and variance
            stat, pvalue = ttest_1samp(data, overall_std_diff)
            std_delay_diff.at[dest, origin] = data.std() if pvalue < (100 -confidence)/100 else overall_std_diff
        else:
            std_delay_diff.at[dest, origin] = overall_std_diff

    return std_delay_diff.fillna(overall_std_diff)


def calculate_expected_delay(path, means_series, mean_arr, mean_flight):
    expected_delay = 0
    for i in range(len(path) - 1):
        if i == 0:
            expected_delay += mean_arr.loc[path[i + 1], path[i]]
            
        else:
            expected_delay += means_series[path[i]]
            expected_delay += mean_flight.loc[path[i + 1], path[i]]
    return expected_delay

def distribution_delay(path, flights_df, first_df, functions, size, initial_state = None):
    delay = 0
    for i in range(len(path) - 1):
        if i == 0:
            if initial_state is not None:
                delay = initial_state
            else:
                delay = first_df.loc[path[i + 1], path[i]](size) 
        else:
            delay += functions[path[i]](size)
            delay += flights_df.loc[path[i + 1], path[i]](size)
    return delay

def get_influences(A: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    U, Sigma, VT = np.linalg.svd(A)
    
    # Create a correctly sized diagonal matrix for Sigma for multiplication
    Sigma_mat = np.zeros((U.shape[1], VT.shape[0]))
    np.fill_diagonal(Sigma_mat, Sigma)
    
    # Correctly perform the matrix multiplication
    origin_influences = VT @ Sigma_mat  # VT has dimensions n x n
    destination_influences = U @ Sigma_mat[:, :U.shape[1]]  # U has dimensions m x m

    # Calculating the norm of each scaled row/column to quantify influence
    origin_impacts = np.linalg.norm(origin_influences, axis=1)
    destination_impacts = np.linalg.norm(destination_influences, axis=0)
    
    return origin_impacts, destination_impacts
