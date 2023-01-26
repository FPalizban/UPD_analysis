# UPD_analysis
Here, we tried to deeply investigate the UPD particularly maternal one’s status in
trio WES data. Prior to further analysis, it is important to carry out the paternity test on the
related data. In this regard vcftools –relatedness2 which uses KING algorithms was applied on
the merged trio VCF file.
Due to the obtained result, the RELATEDNESS_PHI between father and child VCF file is
0.204536 which indicates the first-degree relationship and confirm the paternity status.
Following this step, we attempted to implement a proper pipeline for maternal UPD didection in
trio variant calling files in R. According to the references we can identify maternal UPDs based
on these features: (i) heterozygous in mother’s sample; (ii) homozygous for wild-type allele in
father’s sample; (iii) homozygous for wildtype allele in other unrelated samples in the dataset;
(iv) homozygous for alternative allele in child’s sample.
Accordingly, the automate pipeline for maternal UPD detection based on the mentioned criteria
was implemented in R. This pipeline requires three annotated VCF files (father, mother, and
child’s VCF files) with the information of zygosity status and then by preprocessing and
applying the features, all types of maternal UPDs with their exact location and gene name will be
generated.
After obtaining the UPDs, ROH analysis was also carried out on the proband VCF file for future
confirmation. To fulfill this aim, PLINK was used and the generated .hom file which includes the
runs of homozygosity information in each chromosome.
All the commands and scripts are available in the following step.


# This file includes the commands used for paternity test and ROH analysis steps

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
