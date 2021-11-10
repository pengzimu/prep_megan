# This script is to prepare input PFT files for preprocessing tool of MEGANv2.1.
# To convert global PFT data to several netCDF files, each of which contains precent 
#   of one kind of plant function types.
# The global PFT data is downloaded from https://bai.ess.uci.edu/megan/data-and-code/megan21

# 2021/11/09 by Peng Zimu

library(ncdf4)

inputDir <- "/path/to/downloaded/global/PFT/data"
outputDir <- "/path/to/output"

inFilename <- "mksrf_landuse_rc2000_c110913.nc"


setwd(inputDir)
nc <- nc_open(inFilename)

lon <- ncvar_get(nc, "LON")
lat <- ncvar_get(nc, "LAT")
all_pct_pft <- ncvar_get(nc, "PCT_PFT")
all_pct_pft <- round(all_pct_pft)

nc_close(nc)

lon_dim <- ncdim_def("lon", "degrees_east", lon, longname = "longitude coordinate")
lat_dim <- ncdim_def("lat", "degrees_north", lat, longname = "latitude coordinate")


setwd(outputDir)

for (i in 1:16) {
  
  outFileName <- paste0("pft", sprintf("%02d", i), ".nc")
  outvarname <- paste0("pft", sprintf("%02d", i))
  
  outvar <- ncvar_def(outvarname, "precent", list(lon_dim, lat_dim), -99, 
                      longname = paste0("percent ", outvarname), prec = "byte")
  
  ncnew <- nc_create(outFileName, outvar)
  
  ncvar_put(ncnew, outvar, all_pct_pft[,,i + 1])
  
  nc_close(ncnew)
  
}
