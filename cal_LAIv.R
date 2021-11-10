# This script is to calculate LAIv for MEGANv2.1.
# The output files of LAI and PFT, which are created by preprocessing tool of MEGANv2.1, 
#   are needed as input files.

# 2021/11/10 by Peng Zimu

library(data.table)

outputDir <- "/path/to/output"
outFilename <- "LAIv210.csv"

laifile <- "/path/to/lai/output/LAI210.csv"
pftfile <- "/path/to/pft/output/PFT210.csv"

laidata <- fread(laifile)

# The output csv file is illegal, in which there is a comma at the end of each 
#   line except header line, indicating a null field without column name.
setnames(laidata, names(laidata), c(names(laidata)[2:50], "V1"))
laidata[, V1 := NULL]

pftdata <- fread(pftfile)

# The output csv file is illegal, in which there is a comma at the end of each 
#   line except header line, indicating a null field without column name.
setnames(pftdata, names(pftdata), c(names(pftdata)[2:20], "V1"))
pftdata[, V1 := NULL]

# calculate vegetation cover fraction (VCF) from PFT data
cols <- names(pftdata)[4:19]
VCF <- rowSums(pftdata[, ..cols])
VCF[which(VCF == 0)] <- NA

laiv <- laidata[, 4:49] * 100 / VCF

for (i in names(laiv))
  set(laiv,which(is.na(laiv[[i]])),i,0)


# some values of LAIv may be abnormally high
for (i in names(laiv))
  set(laiv,which(laiv[[i]] > 7),i,7)


laiv <- cbind(laidata[,1:3], laiv)


setwd(outputDir)
write.table(laiv, file = outFilename, sep = ",", quote = FALSE, row.names = FALSE)