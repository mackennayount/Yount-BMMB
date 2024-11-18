# Variables
# Reference genome information
ACC=NC_003210.1
NICKNAME=lmono
REF=refs/${NICKNAME}.fa
GFF=refs/${NICKNAME}.gff

# The sequencing read accession number
SRR=SRR954536

# Reads
N=5000
R1=reads/read1.fq
R2=reads/read2.fq

# The name of the sample (sample alias)
SAMPLE=CFSAN004351

#Alignment files
SAM=align.sam
BAM=align.bam

# The compressed variant call file
VCF=vcf/${NICKNAME}.vcf.gz

# Custom makefile settings.
SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Print the usage of the makefile.
usage:
	@echo "make bam # Create the BAM alignment file"
	@echo "make vcf # Call SNPS in BAM file"
	@echo "make all # Run both bam and vcf together"

# Check that the bio toolbox is installed.
CHECK_FILE = src/run/genbank.mk
${CHECK_FILE}:
	@echo "#"
	@echo "# Please install toolbox with: bio code"
	@echo "#"
	@exit 1

# Create the BAM alignment file.
bam: ${CHECK_FILE}
	# Get the reference genome and the annotations.
	make -f src/run/genbank.mk ACC=${ACC} REF=${REF} GFF=${GFF} fasta gff

	# Index the reference genome.
	make -f src/run/bwa.mk REF=${REF} index

	# Download the sequence data.
	make -f src/run/sra.mk SRR=${SRR} R1=${R1} R2=${R2} N=${N} run

	# Align the reads to the reference genome. 
	# Use a sample name in the readgroup.
	make -f src/run/bwa.mk SM=${SAMPLE} REF=${REF} R1=${R1} R2=${R2} BAM=${BAM} run stats

# Call the SNPs in the resulting BAM file.
vcf:
	make -f src/run/bcftools.mk REF=${REF} BAM=${BAM} VCF=${VCF} run

# Run all the steps.
all: bam vcf

# Remove all the generated files.
clean:
	rm -rf ${REF} ${GFF} ${R1} ${R2} ${BAM} ${VCF}

# These targets do not correspond to files.
.PHONY: bam vcf all usage clean