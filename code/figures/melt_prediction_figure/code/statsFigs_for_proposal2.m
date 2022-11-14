%% plotting frequency graph from Trusel melt rates interpolated onto Bedmap grip by interp_Trusel_on_BM.m

% run interp_Trusel_on_BM.m or load trusel_on_bm.mat (which is faster)

%% threshold and mask
e_threshold = 500

mask = bm.Z == 0 & bs.Z<=e_threshold;

ga = nnz(mask) * bm.cellsize^2;

%% define some locations

% interpolate melt rate at field site
lat_fs = -65.7;
lon_fs = -62.6;
[x_fs,y_fs] = geog_to_pol_wgs84_71S(lat_fs,lon_fs);
% 
pd_melt_fs = griddata(xs,ys,s45_1(:),x_fs,y_fs,'nearest');


% interpolate melt rate at crane glacier 
lat_cg = -65.333333;
lon_cg = -62.25;
[x_cg,y_cg] = geog_to_pol_wgs84_71S(lat_cg,lon_cg);
% 
pd_melt_cg = griddata(xs,ys,s45_1(:),x_cg,y_cg,'nearest');   % the same as the field site


all_AIS_area = nnz(~isnan(bm.Z)) * bm.cellsize^2;
all_GrIS_area = 1.7e6 * 1e6;


%% numbers for opening sentence of AP proposal:

% area that experience melting today and produce lakes (e.g., CG and our field site) is 
nnz(s45_1_on_bm >= pd_melt_cg & ~isnan(bm.Z)) / nnz(~isnan(bm.Z))

% and are predicted to spread to between
nnz(s45_2_on_bm >= pd_melt_cg & ~isnan(bm.Z))   / nnz(~isnan(bm.Z))
% and
nnz(s85_2_on_bm >= pd_melt_cg & ~isnan(bm.Z))   / nnz(~isnan(bm.Z))
% of the ice sheet (ice shelves and grounded ice) 
%this is an increase of a factor of
nnz(s85_2_on_bm >= pd_melt_cg & ~isnan(bm.Z)) / nnz(s45_1_on_bm >= pd_melt_cg & ~isnan(bm.Z))
% and this corresponds to 
nnz(s85_2_on_bm >= pd_melt_cg & ~isnan(bm.Z)) * bm.cellsize^2 /1e6
% km^2

% which is
nnz(s85_2_on_bm >= pd_melt_cg & ~isnan(bm.Z)) * bm.cellsize^2 / (0.22 * all_GrIS_area)
% times the size of greenland's ablation zone (0.22 from Cooper and Smith, 2019):

% fraction of grounded ice sheet that experiences >= 50 mm/a of melting today =
nnz(s45_1_on_bm >= 50 & bm.Z == 0) / nnz(bm.Z == 0)
% this is predicted to increase to between
nnz(s45_2_on_bm >= 50 & bm.Z == 0) / nnz(bm.Z == 0)
% and
nnz(s85_2_on_bm >= 50 & bm.Z == 0) / nnz(bm.Z == 0 )




% fraction of grounded ice sheet below 1000m that experiences melting >= CG of melting today =
nnz(s45_1_on_bm >= 50 & bm.Z == 0 & bs.Z<=1000)   / nnz(bm.Z == 0 & bs.Z<=1000)
% this is predicted to increase to between
nnz(s45_2_on_bm >= 50 & bm.Z == 0 & bs.Z<=1000)   / nnz(bm.Z == 0 & bs.Z<=1000)
% and
nnz(s85_2_on_bm >= 50 & bm.Z == 0 & bs.Z<=1000)   / nnz(bm.Z == 0 & bs.Z<=1000)


% fraction of grounded ice sheet below 500m that experiences melting >= CG of melting today =
nnz(s45_1_on_bm >= pd_melt_cg & bm.Z == 0 & bs.Z<=500)   / nnz(bm.Z == 0 & bs.Z<=500)
% this is predicted to increase to between
nnz(s45_2_on_bm >= pd_melt_cg & bm.Z == 0 & bs.Z<=500)   / nnz(bm.Z == 0 & bs.Z<=500)
% and
nnz(s85_2_on_bm >= pd_melt_cg & bm.Z == 0 & bs.Z<=500)   / nnz(bm.Z == 0 & bs.Z<=500)

% which are 
nnz(s45_2_on_bm >= pd_melt_cg & bm.Z == 0 & bs.Z<=500)  * bm.cellsize^2 / 1e6
% km^2 and 
nnz(s85_2_on_bm >= pd_melt_cg & bm.Z == 0 & bs.Z<=500)  * bm.cellsize^2 / 1e6
% km^2, repectively. 

% total grounded area below 500 m:
nnz(bm.Z == 0 & bs.Z<=500)  * bm.cellsize^2 / 1e6


%% produce full figure showing fractions and predicted increases for figure 2c
m = 1:5:1000

a_45_1 = nan(1,length(m));
a_45_2 = nan(1,length(m));
%a_85_1 = nan(1,length(m));
a_85_2 = nan(1,length(m));


s45_1_on_bm_temp = s45_1_on_bm(mask(:));
s45_2_on_bm_temp = s45_2_on_bm(mask(:));
s85_1_on_bm_temp = s85_1_on_bm(mask(:));
s85_2_on_bm_temp = s85_2_on_bm(mask(:));

for ii = 1:length(m)
    % rcp 4.5 at start of century
    a_45_1(ii) = nnz(s45_1_on_bm_temp >= m(ii))  * bm.cellsize^2;
    
    % rcp 4.5 at end of century
    a_45_2(ii) = nnz(s45_2_on_bm_temp >= m(ii))  * bm.cellsize^2;
    %frac_gt10mm_45_2(ii) = grounded_area_gt10melt_45_2/grounded_area;
        
    % rcp 8.5 at start of century
%     a_85_1(ii) = nnz(s85_1_on_bm_temp >= m(ii) & bm.Z == 0)  * bm.cellsize^2;
    
    % rcp 8.5 at end of century
    a_85_2(ii) = nnz(s85_2_on_bm_temp >= m(ii))  * bm.cellsize^2;
    
    m(ii)
end
    frac_45_1 = a_45_1/ga;
    frac_45_2 = a_45_2/ga;
%     frac_85_1 = a_85_1/ga;
    frac_85_2 = a_85_2/ga;

%%
figure
plot(m,frac_45_1*100,'-g',m,frac_45_2*100,'-k',m,frac_85_2*100,'-b')
xlabel 'melt rate, m [mm/yr]'
ylabel 'percentage of grounded ice with melt rates >= m'
set(gca, 'YScale', 'log')
hold on
ylim([1,100]) 

    

% plot the vertical dashed line showing the melkt rate at the field site
plot([pd_melt_fs pd_melt_fs],ylim,'k--')
legend('present day','2090-2100, RCP4.5','2090-2100, RCP8.5','present-day at CG and FG')
% change the format of the ticklabels
yt = get(gca,'ytick');
for j=1:length(yt)
    YTL{1,j} = num2str(yt(j),'%0.0f');
end
yticklabels(YTL);
title(['threshold= ' num2str(e_threshold) ' m. Total area = ' num2str(ga/1e6) ' km^2'])

print(['/Users/jkingslake/Documents/proposals/NSF/AntPen_NSF_NERC/frac_melt_plot_'  num2str(e_threshold) '.png'],'-dpng') 
print(['/Users/jkingslake/Documents/proposals/NSF/AntPen_NSF_NERC/frac_melt_plot_'  num2str(e_threshold) '.pdf'],'-dpdf') 


%% plot map for figure 2b. 


% annotate the plot
% hold on
% plot(pd_melt_fs,interp1(m,frac_gt10mm_45_1*100,pd_melt_fs),'*k')
% plot(pd_melt_fs,interp1(m,frac_gt10mm_45_2*100,pd_melt_fs),'*g')
% plot(pd_melt_fs,interp1(m,frac_gt10mm_85_2*100,pd_melt_fs),'*r')



s45_1_on_bm_GRID = bm;
s45_1_on_bm_GRID.Z = s45_1_on_bm; 
s45_2_on_bm_GRID = bm;
s45_2_on_bm_GRID.Z = s45_2_on_bm; 
s85_1_on_bm_GRID = bm;
s85_1_on_bm_GRID.Z = s85_1_on_bm; 
s85_2_on_bm_GRID = bm;
s85_2_on_bm_GRID.Z = s85_2_on_bm; 

mask_10 = bm; bm.Z(:) = 1;
mask_10.Z(s85_2_on_bm_GRID.Z<10) = nan;


[xg,yg] = antbounds_data('coast','xy');
plot(xg,yg,'r')
[xg,yg] = antbounds_data('gl','xy');
plot(xg,yg,'r')
mask_gt_FG = bm; mask_gt_FG.Z(:) = 0;
mask_gt_FG.Z(s85_2_on_bm_GRID.Z>pd_melt_fs) = 2;

mask_gt_FG.Z(s45_2_on_bm_GRID.Z>pd_melt_fs) = 1;
hold on
imagesc(mask_gt_FG)

axis([-2600000 2600000 -2300000 2300000])
xlabel 'x [m UPS]'
ylabel 'y [m UPS]'

colormap([1 1 1; 0 1 0; 0 0 1])

% plot field site on map
[x_fs,y_fs] = geog_to_pol_wgs84_71S(lat_fs,lon_fs);
figure(1)
plot(x_fs,y_fs,'r*')


print('/Users/jkingslake/Documents/proposals/NSF/AntPen_NSF_NERC/melt_change_map2.png','-dpng')

% 
% figure
% imagesc(mask_10.*(s85_2_on_bm_GRID-s85_1_on_bm_GRID)./s85_1_on_bm_GRID*100)
% hold on
% contour(s85_1_on_bm_GRID,[pd_melt_fs pd_melt_fs])
% hold on
% contourf(s85_2_on_bm_GRID,[pd_melt_fs pd_melt_fs])
% 
% 
% imagesc(s85_1_on_bm_GRID); title 8.5_1; caxis([0 100])
% figure
% imagesc(s85_2_on_bm_GRID); title 8.5_2; caxis([0 100])


