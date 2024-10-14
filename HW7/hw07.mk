# Ref Seq
REFSEQ="GCF_000196035.1"

#FASTA Files
FASTA_FILE="GCF_000196035.1_ASM196035v1_genomic.fna"
FASTA="listeria.fa"

# Simulated Reads
Nsim=200000
Lsim=150
R1sim=reads/wgsim_read1.fq
R2sim=reads/wgsim_read2.fq

# Set the location of the simulated genome
GENOME="listeria.fa"

# SRR number
SRR=SRR954536

# Reads for trimming
N=22005
R1=reads/${SRR}_1.fastq
R2=reads/${SRR}_2.fastq
T1=reads/${SRR}_1.trimmed.fastq
T2=reads/${SRR}_2.trimmed.fastq

# The reads directory
RDIR=reads

# The reports directory
PDIR=reports

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# Print the help
usage:
	@echo "# ACC=${ACC}"
	@echo "make genome # download SRR number"
	@echo "make refseq # download reference sequence"
	@echo "make simulate # simulate illumina reads"
	@echo "make download # download SRR for trimming"
	@echo "make trim # trim the sequence"
	@echo "make clean # remove the downloaded files"

# ------ The Following are Targets For HW5 ------
refseq:
	download genome acession ${REFSEQ} -- include gff3,genome
	unzip -o ncbi_dataset.zip
	ln -sf ncbi_dataset/data/${REFSEQ}/${FASTA_FILE} ${FASTA}
	echo $(ls -lh ncbi_dataset/data/${REFSEQ})

simulate:
	cat ${FASTA} | head
	echo $(grep -c '>' ${FASTA})
	echo $(grep -v '^>' ${FASTA} | tr -d '\n' | wc -c)
	mkdir -p $(dirname ${R1sim})
	wgsim -N ${Nsim} -1 ${Lsim} -2 ${Lsim} -e 0 -r 0 -R 0 -X 0 ${GENOME} ${R1sim} ${R2sim}
	seqkit stats ${R1sim} ${R2sim}
	echo $(du -sh ${R1sim} ${R2sim})
	gzip ${R1sim} ${R2sim}
	echo $(du -sh ${R1sim} ${R2sim})

# ------ The fllowing are Targets for HW6 ------

download:
	mkdir -p ${RDIR} ${PDIR}
	fastq-dump -X ${N} --split-files -O ${RDIR} ${SRR} 
	fastqc -q -o ${PDIR} ${R1} ${R2}

trim:
	fastp --cut_tail \
	      -i ${R1} -I ${R2} -o ${T1} -O ${T2} 
	fastqc -q -o ${PDIR} ${T1} ${T2}

clean:
	rm -rf ncbi_dataset/data/${ACC}
	rm -f ncbi_dataset.zip

# Mark the targets that do not create files
.PHONY: usage clean