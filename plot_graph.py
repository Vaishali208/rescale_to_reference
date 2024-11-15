import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

query_lengths = pd.read_csv(snakemake.input.query_hist, sep='\t', header=None)
query_lengths = query_lengths[2] - query_lengths[1]

query_hist, bins = np.histogram(query_lengths, bins=np.arange(0, 700, 1), density=True)

adjusted_reference = pd.read_csv(snakemake.input.adjusted_reference_hist, sep=' ', header=None)
adjusted_bins = adjusted_reference[0].values
adjusted_frequencies = adjusted_reference[1].values

plt.figure(figsize=(10, 6))
plt.plot(bins[:-1], query_hist, label='Query', color='purple')
plt.plot(adjusted_bins, adjusted_frequencies, label='Adjusted Query', color='cyan')
plt.legend(loc='upper right')
plt.xlabel('Length')
plt.ylabel('Frequency')
plt.title('Distribution Comparison')
plt.savefig(snakemake.output[0])

