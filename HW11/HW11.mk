# Accession number of the Listeria monocytogenes genome.
ACC=GCF_000196035.1

# The reference file.
REF=refs/lmono.fa

# The GFF file.
GFF=refs/lmono.gff

# The sequencing read accession number.
SRR=SRR30961687

# The number of reads to get
N=5000

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

# Call the SNPs in the resulting BAM file.
vcf: ${CHECK_FILE}
	make -f src/run/bcftools.mk REF=${REF} BAM=${BAM} VCF=${VCF} run

snpeff:
	# Build the custom database
	make -f src/run/snpeff.mk GFF=${GFF} REF=${REF} build

	# Run snpEff using the custom database
	make -f src/run/snpeff.mk GFF=${GFF} REF=${REF} VCF=${VCF} run

# VEP needs a sorted and compressed GFF file.
${GFF}.gz:
	# Sort and compress the GFF file
	# Needs the double $ to pass the $ from make to bash
	cat ${GFF} | sort -k1,1 -k4,4n -k5,5n -t$$'\t' | bgzip -c > ${GFF}.gz

	# Index the GFF file
	tabix -p gff ${GFF}.gz

# VEP is installed in the environment called vep
vep: ${GFF}.gz
	mkdir -p results
	micromamba run -n vep \
		~/src/ensembl-vep/vep \
		-i ${VCF} \
		-o results/vep.txt \
		--gff ${GFF}.gz \
		--fasta ${REF} \
		--force_overwrite 

	# Show the resulting files
	ls -lh results/*

# Run all the steps.
all: bam vcf

# Remove all the generated files.
clean:
	rm -rf ${REF} ${GFF} ${R1} ${R2} ${BAM} ${VCF}

# These targets do not corresposamnd to files.
.PHONY: bam vcf all usage clean