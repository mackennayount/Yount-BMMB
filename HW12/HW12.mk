# Accession number of the Listeria monocytogenes genome.
ACC=GCF_000196035.1


# The reference file.
REF=refs/lmono.fa

# The GFF file.
GFF=refs/lmono.gff

# The sequencing read accession number.
SRR=SRR10085689

# The number of reads to get
N=5000

# Sample name
SAMPLE=SAMN12715982

# The path to read 1
R1=reads/${SRR}_1.fastq

# The path to read 2
R2=reads/${SRR}_2.fastq

# The resulting BAM file.
BAM=bam/${SRR}.bam

# The resulting variant VCF file (compressed!).
VCF=vcf/${SRR}.vcf.gz

# ------ DO NOT CHANGE BELOW THIS LINE ------

# Set the shell the commands run in.
SHELL = bash

# Execute all commands in a single shell.
.ONESHELL:

# Run the shell with strict error checking.
.SHELLFLAGS = -eu -o pipefail -c

# Delete target files if the command fails.
.DELETE_ON_ERROR:

# Warn if a variable is not defined.
MAKEFLAGS += --warn-undefined-variables

# Disable built-in rules.
MAKEFLAGS += --no-builtin-rules

# Print the usage of the makefile.
usage:
	@echo "# ACC=${ACC}"
	@echo "# SRR=${SRR}"
	@echo "# SAMPLE=${SAMPLE}"
	@echo "# BAM=${BAM}"
	@echo "# VCF=${VCF}"
	@echo "# make bam # create the BAM file, index it, and align to reference genome"
	@echo "# make vcf # call variants from BAM file"
	@echo "# make all"

# Create the BAM alignment file.
bam: 
	# Get the reference genome and the annotations.
	mkdir -p $(dir ${REF})
	datasets download genome accession ${ACC}
	unzip -n ncbi_dataset.zip -x README.md md5sum.txt
	cp -f ncbi_dataset/data/${ACC}*/${ACC}*_genomic.fna ${REF}

	# Index the reference genome.
	bwa index ${REF}

	# Download the sequence data.
	mkdir -p $(dir ${R1})
	fastq-dump -X ${N} --outdir reads --split-files ${SRR}

	# Align the reads to the reference genome. 
	mkdir -p $(dir ${BAM})
	bwa mem -t 4 ${REF} ${R1} ${R2} | samtools sort > ${BAM}
	samtools index ${BAM}
	
	# Generate alignment stats
	samtools flagstat ${BAM}

# Check that the bio toolbox is installed.
CHECK_FILE = src/run/genbank.mk
${CHECK_FILE}:
	@echo "#"
	@echo "# Please install toolbox with: bio code"
	@echo "#"
	@exit 1

# Call the SNPs in the resulting BAM file.
vcf: ${CHECK_FILE}
	make -f src/run/bcftools.mk REF=${REF} BAM=${BAM} VCF=${VCF} run

# Run all the steps.
all: bam vcf

# Remove all the generated files.
clean:
	rm -rf ncbi_dataset/data/${ACC}
	rm -rf ${REF} ${GFF} ${R1} ${R2} ${BAM} ${VCF} ${BAM}.bai

# These targets do not corresposamnd to files.
.PHONY: bam vcf all usage clean