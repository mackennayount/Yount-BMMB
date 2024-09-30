# Set the error handling and trace
set -uex

# Define all variables at the top.

# The NCBI RefSeq assembly number
REFSEQ="GCF_000196035.1"
FASTA_FILE="GCF_000196035.1_ASM196035v1_genomic.fna"
FASTA="listeria.fa"

# ------ All the actions follow ------

# Download data by RefSeq assembly from NCBI and make sure all necessary files are included
datasets download genome accession ${REFSEQ} --include gff3,genome

# Unzip the dataset (overwrite any files if they already exist)
unzip -o ncbi_dataset.zip

# Make a link to a simpler name
ln -sf ncbi_dataset/data/${REFSEQ}/${FASTA_FILE} ${FASTA}

# List files in the directory with a summary to see the sizes of the files
echo $(ls -lh ncbi_dataset/data/${REFSEQ})

# Open and view the dataset
cat ${FASTA} | head

# Count the number of sequences/chromosomes in the FASTA file and print the output
echo $(grep -c '>' ${FASTA})

# Count the number of bases in the chromosome and print the output
echo $(grep -v '^>' ${FASTA} | tr -d '\n' | wc -c)

#
# Simulate reads with wgsim
#

# Set the location of the genome
GENOME="listeria.fa"

# Set the number of reads to generate
N=200000

# Set the read length
L=150

# The files to write the reads to
R1=reads/wgsim_read1.fq
R2=reads/wgsim_read2.fq

# Make the directory for the reads
mkdir -p $(dirname ${R1})

# Simulate the reads with no errors and no mutations
wgsim -N ${N} -1 ${L} -2 ${L} -e 0 -r 0 -R 0 -X 0 ${GENOME} ${R1} ${R2}

# Run read statistics
seqkit stats ${R1} ${R2}

# Calculate the size of the FASTQ files
echo $(du -sh ${R1} ${R2})

# Compress the files
gzip ${R1} ${R2}

# Calculate the space saved
echo $(du -sh ${R1} ${R2})