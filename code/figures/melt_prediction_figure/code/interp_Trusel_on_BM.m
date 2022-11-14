%% get info on the NC
i = ncinfo('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp45.nc');

%% load the netcdfs
s45 = ncread('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp45.nc','snm');  %'mm w.e. a-1'
s85 = ncread('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp85.nc','snm');  %'mm w.e. a-1'
lat = ncread('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp45.nc','lat');
lon = ncread('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp45.nc','lon');
time = ncread('snm_truselNatGeosci2015_rcp45_rcp85/snm_CMIP5-CLM4-EnsembleMean_truselNatGeosci2015_rcp45.nc','time');  %'days since 2005-01-01 00:00:00'

%% convert the time to datetime extract two periods 2010-2019 and 2091-2100. 
time = datetime('2005-01-01 00:00:00') + time;
y = time.Year;
i1 = find(y>=2010 & y<2020);
i2 = find(y>2090);
y(i1)
y(i2)

%% average over thee two periods
s45_1 = mean(s45(:,:,i1),3);
s45_2 = mean(s45(:,:,i2),3);

s85_1 = mean(s85(:,:,i1),3);
s85_2 = mean(s85(:,:,i2),3);


%% convert lat/lon to ups
[xs,ys] = geog_to_pol_wgs84_71S(lat(:),lon(:));

%% load bedmap mask and extract coords
bm = GRIDobj('bedmap2_icemask_grounded_and_shelves.tif');
bs = GRIDobj('bedmap2_surface.tif');

[xb,yb] = getcoordinates(bm);
[xbm,ybm] = meshgrid(xb,yb);

%% interpolate the melt data at every bedmap point
s45_1_on_bm = griddata(xs,ys,s45_1(:),xbm,ybm,'nearest');
s45_2_on_bm = griddata(xs,ys,s45_2(:),xbm,ybm,'nearest');
s85_1_on_bm = griddata(xs,ys,s85_1(:),xbm,ybm,'nearest');
s85_2_on_bm = griddata(xs,ys,s85_2(:),xbm,ybm,'nearest');


% sanity check on area of Antarctic grounded ice: pi*3000000^2 is the same
% order of mag at grounded_area

%% plot of melt rates and the grounding line
figure(2)
imagesc(xb,yb,s45_1_on_bm);   set(gca,'YDir','normal')
caxis([0 500])
[xg,yg] = antbounds_data('gl','xy');
hold on
plot(xg,yg,'r')


% %% percentage of grounded area that has melt> 10 mm/yr
% 
% % rcp 4.5 at start of century
grounded_area_gt10mm_45_1 = nnz(s45_1_on_bm >= 10 & bm.Z == 0)  * bm.cellsize^2;
frac_gt10mm_45_1 = grounded_area_gt10mm_45_1/grounded_area 
% 
% % rcp 4.5 at end of century
% grounded_area_gt10melt_45_2 = nnz(s45_2_on_bm >= 10 & bm.Z == 0)  * bm.cellsize^2;
% frac_gt10mm_45_2 = grounded_area_gt10melt_45_2/grounded_area 
% 
% % rcp 8.5 at start of century
% grounded_area_gt10mm_85_1 = nnz(s85_1_on_bm >= 10 & bm.Z == 0)  * bm.cellsize^2;
% frac_gt10mm_85_1 = grounded_area_gt10mm_85_1/grounded_area 
% 
% % rcp 8.5 at end of century
% grounded_area_gt10melt_85_2 = nnz(s85_2_on_bm >= 10 & bm.Z == 0)  * bm.cellsize^2;
% frac_gt10mm_85_2 = grounded_area_gt10melt_85_2/grounded_area 


