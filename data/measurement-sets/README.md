# Measurement Sets Directory

This directory contains sample measurement sets for Exercise 4.

## Note

Due to the large size of measurement sets, this repository includes a placeholder structure. 
For the actual workshop, measurement sets will be provided via:

1. **Direct download**: Links will be shared before the workshop
2. **Cloud storage**: Pre-loaded on JupyterHub instances
3. **USB drives**: Available at in-person workshops

## Creating a Placeholder MS

For testing without real data, create a placeholder directory:

```bash
mkdir -p example.ms
touch example.ms/table.dat
touch example.ms/ANTENNA
touch example.ms/DATA_DESCRIPTION
touch example.ms/FEED
touch example.ms/FIELD
touch example.ms/FLAG_CMD
touch example.ms/HISTORY
touch example.ms/OBSERVATION
touch example.ms/POINTING
touch example.ms/POLARIZATION
touch example.ms/PROCESSOR
touch example.ms/SOURCE
touch example.ms/SPECTRAL_WINDOW
touch example.ms/STATE
```

## Expected Data Format

Measurement sets should include:
- Visibility data (DATA or CORRECTED_DATA columns)
- Calibrator and target source observations
- Full Stokes or at minimum dual-polarization

## Size Estimates

- Small test MS: ~100 MB
- Typical workshop MS: ~500 MB - 1 GB
- Full observation MS: 10+ GB
