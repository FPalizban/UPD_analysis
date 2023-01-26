# UPD_analysis

Conversation opened. 1 read message.

Skip to content
Using Gmail with screen readers
upd 
UPD- analysis

fahimeh palizban <palizbanfahimeh@gmail.com>
Attachments
Fri, Sep 24, 2021, 12:00 PM
to Amir, amir.hossein.saeidian

Hello,
 I tried to prepare the mentioned documents explaining the method section of the UPD analysis along with paternity and ROH tests.
Please find the attached and inform me of your comments.
Thanks
Fahimeh 
7
 Attachments
  •  Scanned by Gmail
# This file includes the commands used for paternity test and ROH analysis steps
# 9.24.2021 by Fahimeh Palizban




#### preparing VCF files for paternety test analysis based on WES ############
( each command is repeated for mother and father VCF file as well)

# remove polyploidy from each raw VCF file 

$  bcftools +fixploidy child.vcf> child_fixed.vcf  

# zip the VCF file

$  bgzip -c child_fixed.vcf > child_fixed.vcf.gz


# index VCF file 

$ bcftools index child_fixed.vcf.gz

# merge all the VCF files of the family

$ bcftools merge *.vcf.gz -Oz -o merged.vcf.gz

# identifying the relatedness between the members of the family based on KING method 

$  vcftools --gzvcf merged.vcf.gz --relatedness2 --out ajk

#### ROH analysis by using PLINK 

# converting raw VCF file for PLINK-suitable input

$  vcftools --vcf child_fixed.vcf --plink --out myplink

# apply PLINK

$ plink --bfile UPD-Child --homozyg --allow-extra-chr --double-id --homozyg-window-snp 2 --homozyg-snp 2 --homozyg-kb 2000 --homozyg-density 100 --homozyg-window-het 2

 
upd_readme.txt
Displaying upd_readme.txt.
