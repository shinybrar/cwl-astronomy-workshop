#!/usr/bin/env python3
"""Generate sample FITS files for workshop exercises."""

import numpy as np
from astropy.io import fits
from astropy.wcs import WCS
import os

def create_sample_observation():
    """Create a sample observation FITS file."""
    
    # Create image data - simulated galaxy field
    size = 512
    image = np.random.randn(size, size) * 0.001  # Background noise
    
    # Add some simulated sources
    np.random.seed(42)
    for _ in range(20):
        x = np.random.randint(50, size-50)
        y = np.random.randint(50, size-50)
        flux = np.random.exponential(0.05)
        sigma = np.random.uniform(3, 8)
        
        yy, xx = np.ogrid[:size, :size]
        gaussian = flux * np.exp(-((xx-x)**2 + (yy-y)**2) / (2*sigma**2))
        image += gaussian
    
    # Create WCS
    wcs = WCS(naxis=2)
    wcs.wcs.crpix = [size/2, size/2]
    wcs.wcs.cdelt = [-0.001, 0.001]  # 3.6 arcsec pixels
    wcs.wcs.crval = [180.0, 45.0]  # RA, Dec
    wcs.wcs.ctype = ["RA---TAN", "DEC--TAN"]
    
    # Create header
    header = wcs.to_header()
    header['OBJECT'] = 'Workshop Sample Field'
    header['TELESCOP'] = 'SKA-MID'
    header['INSTRUME'] = 'Band 2'
    header['DATE-OBS'] = '2025-01-15T12:00:00'
    header['EXPTIME'] = 3600.0
    header['BUNIT'] = 'JY/BEAM'
    header['BMAJ'] = 0.001
    header['BMIN'] = 0.0008
    header['BPA'] = 45.0
    header['FREQ'] = 1.4e9
    header['OBSERVER'] = 'CWL Workshop'
    
    # Create HDU and write
    hdu = fits.PrimaryHDU(data=image.astype(np.float32), header=header)
    
    output_dir = os.path.dirname(os.path.abspath(__file__))
    output_path = os.path.join(output_dir, 'observation.fits')
    hdu.writeto(output_path, overwrite=True)
    print(f"Created: {output_path}")

def create_calibrator_fits():
    """Create a calibrator source FITS file."""
    
    size = 256
    image = np.random.randn(size, size) * 0.0005
    
    # Add bright point source at center
    yy, xx = np.ogrid[:size, :size]
    center = size / 2
    gaussian = 1.0 * np.exp(-((xx-center)**2 + (yy-center)**2) / (2*5**2))
    image += gaussian
    
    header = fits.Header()
    header['OBJECT'] = '3C286'
    header['TELESCOP'] = 'SKA-MID'
    header['DATE-OBS'] = '2025-01-15T10:00:00'
    header['EXPTIME'] = 600.0
    header['BUNIT'] = 'JY/BEAM'
    header['COMMENT'] = 'Calibrator observation for CWL workshop'
    
    hdu = fits.PrimaryHDU(data=image.astype(np.float32), header=header)
    
    output_dir = os.path.dirname(os.path.abspath(__file__))
    output_path = os.path.join(output_dir, 'calibrator.fits')
    hdu.writeto(output_path, overwrite=True)
    print(f"Created: {output_path}")

if __name__ == "__main__":
    print("Generating sample FITS files...")
    create_sample_observation()
    create_calibrator_fits()
    print("Done!")
