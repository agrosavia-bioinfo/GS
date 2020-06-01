#!/usr/bin/Rscript

# Convert GWASpoly genotype, phenotype to numeric genotype (
# out genotype: Only individuals X markers
# out map file: SNPs|CHROM|POS

#----------------------------------------------------------
# Util to print head of data
# Fast head, for debug only
#----------------------------------------------------------
hd <- function (data, m=10,n=10) {
	message (deparse (substitute (data)),":")
	if (is.null (dim (data)))
		print (data [1:10])
	else if (ncol (data) < 10)
		print (data[1:m,])
	else if (nrow (data) < 10)
		print (data[,1:n])
	else
		print (data [1:m, 1:n])
}

#----------------------------------------------------------
args = commandArgs (trailingOnly=T)
args = c("example-genotype.tbl", "example-phenotype.tbl")
options (width=300)

genoFile  = args [1]
phenoFile = args [2]

geno  = read.csv (file=genoFile, row.names = 1, check.names=F)
pheno = read.csv (file=phenoFile, check.names=F, row.names=1)

genoMarkers = geno [,-c(1:2)]
genoMap     = geno [,c(1:2)]
genoSamples = t (genoMarkers)

gnames = rownames (genoSamples)
pnames = rownames (pheno)

# Common names
commonNames = intersect (gnames, pnames)

genoNum  = genoSamples [sort (commonNames),] 
phenoNum = pheno [commonNames,,drop=F]

# Create new names
outGenoFile  = paste0 (strsplit (genoFile, split="[.]")[[1]][1],"-num.tbl")
outPhenoFile = paste0 (strsplit (phenoFile, split="[.]")[[1]][1],"-num.tbl")
outMapFile   = paste0 (strsplit (genoFile, split="[.]")[[1]][1],"-map-num.tbl")

# Add rownames as first column
fullGeno  = cbind (NAME=rownames(genoNum), genoNum)
fullPheno = cbind (NAME=rownames(phenoNum), phenoNum)
fullMap   = cbind (SNP=rownames(genoMap), genoMap)

write.csv  (file=outGenoFile, fullGeno, quote=F, row.names=F)
write.csv  (file=outPhenoFile, fullPheno, quote=F, row.names=F)
write.csv  (file=outMapFile, fullMap, quote=F, row.names=F)

					 
