import os
import numpy as np
import sys
import os
sys.path.append('/Users/jkingslake/Documents/science/pdemtools/src')
import pdemtools as pdt
import xarray as xr


from scipy.ndimage import binary_erosion


def coreg_hillshade(dem_name_1, 
                    dem_name_2,
                    dem_dir = "../../../remote sensing/worldview/6158_2025apr22_Kingslake_2024_25_DEMs/dem/",
                    vnumber = '_v040316',
                    SETM_prefix = 'SETSM_s2s041_',
                    erode_iterations = 20,
                    hillshade_z_factor = 2,
                    ):
    """
    Coregisters two DEMs and computes hillshade and elevation change.

    dem_name_2 is coregistered to dem_name_1

    Parameters
    ----------
    dem_name_1 : str
        Name of the first DEM. This is the DEM to which the second DEM will be coregistered.
    dem_name_2 : str
        Name of the second DEM. This is the DEM that will be coregistered to the first DEM.
    dem_dir : str
        Directory where the DEMs are stored. Default is "../../../remote sensing/worldview/6158_2025apr22_Kingslake_2024_25_DEMs/dem/".
    vnumber : str
        Version number of the DEMs. Default is '_v040316'.
    SETM_prefix : str
        Prefix of the DEM files. Default is 'SETSM_s2s041_'.
    erode_iterations : int
        Number of iterations for the erosion of the bedrock mask. Default is 20.
    hillshade_z_factor : int
        vertical exaggeration hillshade calculation. Default is 2.
    Returns
    -------
    out : xarray.Dataset
        xarray dataset containing the coregistered DEM, the first DEM, the elevation change, the eroded bedrock mask, and the hillshade.

    """

    params = {'hillshade_z_factor': hillshade_z_factor, 'erode_iterations': erode_iterations}


    print('gathering file paths and dates')
    dem_1_fpath = os.path.join(dem_dir, dem_name_1 + vnumber, SETM_prefix + dem_name_1 + '_seg1_dem.tif')
    bitmask_1_fpath = os.path.join(dem_dir, dem_name_1 + vnumber, SETM_prefix + dem_name_1 + '_seg1_bitmask.tif')
    dem_1 = pdt.load.from_fpath(dem_1_fpath,  bitmask_fpath=bitmask_1_fpath)
    dem_2_fpath = os.path.join(dem_dir, dem_name_2 + vnumber, SETM_prefix + dem_name_2 + '_seg1_dem.tif')
    bitmask_2_fpath = os.path.join(dem_dir, dem_name_2 + vnumber, SETM_prefix + dem_name_2 + '_seg1_bitmask.tif')
    dem_2 = pdt.load.from_fpath(dem_2_fpath, bitmask_fpath=bitmask_2_fpath)

    def get_date(fn):
        # get the filename without the extension
        filename = os.path.basename(fn)
        # split the filename into parts
        parts = filename.split('_')
        # get the date part (the 4th part in this case)
        date_part = parts[3]
        # format the date part as YYYYMMDD
        date = f"{date_part[:4]}_{date_part[4:6]}_{date_part[6:]}"
        return date
    date_1 = get_date(dem_1_fpath)
    date_2 = get_date(dem_2_fpath)
    
    dz_no_coreg = dem_2 - dem_1
    bounds = dz_no_coreg.rio.bounds()

    print('loading dems')
    dem_1 = pdt.load.from_fpath(dem_1_fpath, bounds=bounds, pad=True, bitmask_fpath=bitmask_1_fpath, chunks=True).rename('dem_1')
    dem_2 = pdt.load.from_fpath(dem_2_fpath, bounds=bounds, pad=True, bitmask_fpath=bitmask_2_fpath, chunks=True).rename('dem_2_not_coreg')

    dem_1.attrs['description'] = 'DEM 1'
    dem_2.attrs['description'] = 'DEM 2 not coregistered'
    dem_1.attrs['date'] = date_1
    dem_2.attrs['date'] = date_2
    dem_1.attrs['dem_name'] = dem_name_1
    dem_2.attrs['dem_name'] = dem_name_2
    dem_1.attrs['dem_path'] = dem_1_fpath
    dem_2.attrs['dem_path'] = dem_2_fpath

    bedrock_mask=pdt.data.bedrock_mask_from_vector('/Users/jkingslake/Documents/data/quantarctica/Quantarctica3/Geology/ADD/ADD_RockOutcrops_Landsat8.shp', dem_1)

    print('eroding bedrock mask')
    def erode(da):
        eroded = binary_erosion(da.data, iterations = erode_iterations)
        return xr.DataArray(eroded, dims=da.dims, coords=da.coords, attrs=da.attrs).astype(np.uint8)

    eroded_mask = erode(bedrock_mask).rename('eroded_bedrock_mask')
    eroded_mask.attrs['description'] = 'Bedrock mask produced by eroding a mask from Quantarctica: ADD_RockOutcrops_Landsat8.shp'
    eroded_mask.attrs['erode_iterations'] = erode_iterations

    print('coregistering dem_2 to dem_1')
    dem_2_coreg, metadata_coreg_bedrock = dem_2.pdt.coregister_dems(
                                                            dem_1,
                                                            stable_mask=eroded_mask,
                                                            return_stats=True)
    dem_2_coreg = dem_2_coreg.rename('dem_2')
    dem_2_coreg.attrs['coreg_metadata'] = metadata_coreg_bedrock
    
    print('computing elevation change')
    dH =  (dem_2_coreg - dem_1).rename('dH')
    dH.attrs['units'] = 'm'
    dH.attrs['description'] = 'Elevation change between dem_2 and dem_1, coregistered to dem_1'
    dH.attrs['DEM dates'] = [date_1, date_2]

    # compute hillshade
    print('computing hillshade')
    hillshade_1 = dem_1.pdt.terrain('hillshade', hillshade_multidirectional=True, hillshade_z_factor=hillshade_z_factor).rename('hillshade_1')
    hillshade_2 = dem_2_coreg.pdt.terrain('hillshade', hillshade_multidirectional=True, hillshade_z_factor=hillshade_z_factor).rename('hillshade_2')


    hillshade_1.attrs['description'] = 'Hillshade of dem_1'
    hillshade_2.attrs['description'] = f'Hillshade of dem_2 coregistered to the den from {date_1})'
    hillshade_1.attrs['hillshade_z_factor'] = hillshade_z_factor
    hillshade_2.attrs['hillshade_z_factor'] = hillshade_z_factor
    hillshade_1.attrs['hillshade_multidirectional'] = True
    hillshade_2.attrs['hillshade_multidirectional'] = True
    hillshade_1.attrs['date'] = date_1
    hillshade_2.attrs['date'] = date_2
    
    out =  xr.merge([dem_2_coreg, dem_1, dH, eroded_mask, hillshade_1, hillshade_2])
    out.attrs['coreg_metadata'] = metadata_coreg_bedrock
    out.attrs['parameters'] = params

    return out