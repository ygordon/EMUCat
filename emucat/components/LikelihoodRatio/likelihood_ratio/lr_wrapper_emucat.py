###wrapper for EMUcat likelihood ratio code
###takes VOTable EMUcat files
###converts to work with LoTSS LR code
###runs LR
###converts output back to VOTable for EMUcat


import argparse, subprocess, os, numpy as np, pandas as pd
from astropy.table import Table
from astropy.io import fits
from astropy.wcs import WCS

###########################################################################
###def functions

def fake_mask(catfile, catformat='votable', acol='ra', dcol='dec',
              outfile='fakemask.fits', npx=4095, overwrite=True):
    
    'fake a mask image (all unmasked) to enable LR code to run using just catalogue info'
    'use AllWISE image parameters, set array values to 1'
    'in lieu of dowloading AllWISE images and mask on the fly'
    'this will let code run but needs science verification - is the output still good?'
    
    ###obtain ref ra/dec for fake mask from catalogue data
    catdata = Table.read(catfile, format=catformat)
    ra, dec = np.array(catdata[acol]), np.array(catdata[dcol])
    
    ##dec easy, ra needs to account for ra wrapping at 360/0deg
    acen = np.min(ra) + ((np.max(ra)-np.min(ra))/2)
    dcen = np.min(dec) + ((np.max(dec)-np.min(dec))/2)
    ###account for ra wrapping at 360 - n.b. will break if cone search radius is >90deg!!!
    if np.max(ra) - np.min(ra) > 180:
        acen = (360-np.max(ra)) + ((np.min(ra)-(360-np.max(ra)))/2)
    
    
    ###create data array (4095x4095)
    unmasked_array = np.zeros((npx, npx))
    
    ##create fits primary HDU
    hdu = fits.PrimaryHDU(unmasked_array)
    
    ###adjust header to privide necessary wcs information
    hdu.header['CTYPE1'] = 'RA---SIN'
    hdu.header['CTYPE2'] = 'DEC--SIN'
    hdu.header['CRVAL1'] = acen
    hdu.header['CRVAL2'] = dcen
    hdu.header['CRPIX1'] = npx/2
    hdu.header['CRPIX2'] = npx/2
    hdu.header['CDELT1'] = -0.0003819444391411
    hdu.header['CDELT2'] = 0.0003819444391411
    hdu.header['CUNIT1'] = 'deg'
    hdu.header['CUNIT2'] = 'deg'
    
    ###convert to HDU list and write to file
    hdul = fits.HDUList(hdu)
    
    hdul.writeto(outfile, overwrite=overwrite)
    return


def add_mask_and_stargal_cols(mwfile, fileformat='fits'):
    'add Mask and Stargal columns to multiwavelength data'
    'set all to good for now, update later - stargal can exploit WISE colours'
    
    data = Table.read(mwfile, format=fileformat)
    
    ###mask 0 = good
    ###sg 1 = good
    maskarray = np.zeros(len(data))
    sgarray = np.ones(len(data))
    
    data['Mask'] = maskarray
    data['stargal'] = sgarray
    
    data.write(mwfile, overwrite=True)
    
    return


def VOTable_to_fits(fname_in, fname_out, over_write=True):
    ###create fits copy of VOTable from EMUcat for use with LR code
    data = Table.read(fname_in)
    data.write(fname_out, format='fits', overwrite=over_write)
    return


def output_to_VOTable(fname_in, fname_out, over_write=True):
    data = Table.read(fname_in, format='ascii')
    data.write(fname_out, format='votable')
    return


def run_lr(fakefile='fakemask.fits', racol='ra', deccol='dec'):
    'run wrapped likelihood ratio code'
    'io format: VOTables'
    
    ##parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('mwcat', type=str,
                        help='multiwavelength data VOTable to convert to fits for LR code')
    parser.add_argument('radcat', type=str,
                        help='radio data VOTable to convert to fits for LR code')
    args = parser.parse_args()
    
    ###extract info from config file - need outdir
    config_info = pd.read_table('lr_config.txt',
                                delim_whitespace=True).replace("'", "", regex=True)
    outdir = config_info[(config_info['parameter']=='outdir')].iloc[0]['value']
                        
    ##list current directory contents - helps cleaning up
    keep_files = os.listdir()
    
    ###create fits tables for mw/radcat
    table_data = [args.mwcat, args.radcat]
    fitsnames = [fname.split('.')[0]+'.fits' for fname in table_data]
    for i in range(len(table_data)):
        VOTable_to_fits(fname_in=table_data[i], fname_out=fitsnames[i])
    
    ###add in mask and stargal columns
    add_mask_and_stargal_cols(mwfile=fitsnames[0])
    
    ###need to place here what to do about mask image, currently assumes present
    fake_mask(catfile=args.mwcat, acol=racol, dcol=deccol, outfile=fakefile)
    mask = fakefile

    ###run LR code - comment out during testing once confirmed works
    command_args = ['python3', 'likelihood_ratio_matching.py', fitsnames[0],
                    fitsnames[1], mask]
    lr = subprocess.Popen(command_args, stdout=subprocess.PIPE, universal_newlines=True)
    lr.wait() ##ensures LR process finishes before code continues

    ###convert outputs (keep those that end in '_LR_matches.dat') to VOTable
    if outdir!='':
        file_list = os.listdir(outdir)
        outdir = outdir+'/'
    else:
        file_list = os.listdir()
    for filename in file_list:
        if '_LR_matches.dat' in filename:
            newname = outdir+filename.split('.')[0] + '.xml'
            output_to_VOTable(fname_in=filename, fname_out=newname)
            keep_files.append(newname)

    ##tidy up - get rid of surplus (add in moving files to target directory)
    ###this step may not be needed with Lingling's changes to the LR code
    ###or at least is likely to need changing - test with lingling's new code
    for filename in file_list:
        if filename not in keep_files:
            os.remove(filename)
    return

###########################################################################
####test


###for now assume data exists in same directory
#mwcat = '3184m576_pw1cat.xml' - cmd line argument
#radcat = 'EMU_PS9442_compcat.xml' - cmd line argument
#mask = 'uw_3184m576_mask.fits' ## - needs to be grabbed/faked on the fly
#mask = 'fakemask.fits' ## - fake test

run_lr()


###to do: adjust to create fake mask image (upgrade to grab and mosaic WISE images)


###########################################################################


###########################################################################
