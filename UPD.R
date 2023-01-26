rm(list=ls())
getwd()
setwd("C:/Users/Click/Desktop/")

################ import annotated vcf file #################
ch <- read.table("ch.annovar.variant_function")
mo <- read.table("mo.annovar.variant_function")
fa <- read.table("fa.annovar.variant_function")

############## call libraries #######################
library(stringr)
library(dplyr)
library(splitstackshape)

############# maternal UPD ###############
ch_hom <-ch %>%
  filter(str_detect(V8, "hom"))
mo_het <-mo %>%
  filter(str_detect(V8, "het"))
fa_hom <-fa %>%
  filter(str_detect(V8, "hom"))

head(ch_hom)

######################
ch_ex <-ch_hom %>%
  filter(str_detect(V1, "exonic"))
mo_ex <-mo_het %>%
  filter(str_detect(V1, "exonic"))
fa_ex <-fa_hom %>%
  filter(str_detect(V1, "exonic"))


ch_mer <- as.data.frame(paste(ch_ex$V6,"-",ch_ex$V7,sep = ""))
mo_mer <- as.data.frame(paste(mo_ex$V6,"-",mo_ex$V7,sep = ""))
fa_mer <- as.data.frame(paste(fa_ex$V6,"-",fa_ex$V7,sep = ""))


ch_f <- as.data.frame(cbind(ch_ex$V2,ch_ex$V3,ch_ex$V4, ch_mer,ch_ex$V8))
mo_f <-  as.data.frame(cbind(mo_ex$V2,mo_ex$V3,mo_ex$V4, mo_mer,mo_ex$V8))

colnames(ch_f) <- c('V1','V2','V3','V4','V5')
colnames(mo_f) <- c('V1','V2','V3','V4','V5')



ch_p <- as.data.frame(paste(ch_f$V1,".",ch_f$V2,".",ch_f$V3,".", ch_f$V4,sep = ""))
mo_p <- as.data.frame(paste(mo_f$V1,".",mo_f$V2,".",mo_f$V3,".", mo_f$V4,sep = ""))

father <- as.data.frame(paste(fa$V3,".",fa$V4,sep = ""))


colnames(father)[1] <- "pos"
colnames(father)[2] <- "father"

colnames(ch_p)[1] <- "child"
colnames(mo_p)[1] <- "mother"


ch_l <- as.data.frame(cbind(ch_p,ch_f$V5))
mo_l <- as.data.frame(cbind(mo_p,mo_f$V5))


colnames(ch_l)[2] <- "child"
colnames(mo_l)[2] <- "mother"


colnames(ch_l)[1] <- "pos"
colnames(mo_l)[1] <- "pos"


ch_mo <- inner_join(mo_l,ch_l)

split <- cSplit(ch_mo, 'pos', sep=".")
split_mer <- as.data.frame(paste(split$pos_2,".",split$pos_3,sep = ""))
colnames(split_mer)[1] <- "pos"

split_fa <- cSplit(fa_l, 'pos', sep=".")
split_mer_fa <- as.data.frame(paste(split_fa$pos_02,".",split_fa$pos_03,sep = ""))
head(split_mer_fa)
colnames(split_mer_fa)[1] <- "pos"


maternal_upd <- setdiff(split_mer, split_mer_fa)
write.csv(maternal_upd,file = "maternal_upd.csv")



