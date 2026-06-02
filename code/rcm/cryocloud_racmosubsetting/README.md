# Loading and subsetting RACMO 2km daily data from 1979-2025

Takes many nc files provided by Brice Noel and


with download_upload_to_scratch_xxxxxx.ipynb
1. downloads each one and saves it temporarily in the notebook workspace area
2. loads each one
3. writes it to a zarr in the cryocloud stratch drive

with xxxxx_rechunk_append.ipynb
4. Loads each zarr
5. rechunks to time: 1
6. Appends to one large zarr for each of four variables. 

with merge_subset.ipynb
7. Loads all four large zarrs
8. merges them
9. Subsets this merged dataset to a given region 
10. rechunks and writes the small array. 
