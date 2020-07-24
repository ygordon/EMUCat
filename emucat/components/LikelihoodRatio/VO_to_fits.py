###needs to take VOTable EMUcat output and convert to fits for Morabito LR to work
###also what to do about mask images - download and process on the fly as per VLASS cat?

import argparse
from astropy.table import Table

def VOTable_to_fits(filename, over_write=True):
    ###create fits copy of VOTable from EMUcat for use with LR code
    data = Table.read(filename)
    data.write(filename + '.fits', format='fits', overwrite=over_write)
    return


####parse command line args
parser = argparse.ArgumentParser()
parser.add_argument('mwcat', type=str,
                    help='multiwavelength data VOTable to convert to fits for LR code')
parser.add_argument('radcat', type=str,
                    help='radio data VOTable to convert to fits for LR code')

args = parser.parse_args()


VOTable_to_fits(filename=args.mwcat)
VOTable_to_fits(filename=args.radcat)

