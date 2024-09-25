# Set the error handling and trace
set -uex

# Define all variables at the top.

# The NCBI acession number
ACCESSION="GCF_000196035.1"

# ------ All the actions follow ------

# Download data by acession from NCBI and make sure all necessary files are included
datasets download genome accession ${ACCESSION} --include gff3,rna,cds,protein,genome,seq-report

# Unzip the dataset
unzip ncbi_dataset.zip

# Open and view the dataset
cat ncbi_dataset/data/${ACCESSION}/genomic.gff | head

# Remove all lines beginning with # and save to a new file
cat ncbi_dataset/data/${ACCESSION}/genomic.gff | grep -v '^#' > mydata.gff

# Separate gene and CDS features into diffeent files
cat mydata.gff | awk ' $3=="gene" { print $0 }' > gene.gff
cat mydata.gff | awk ' $3=="CDS" { print $0 }' > cds.gff

# These two files will be used in IGV to visualize the gene and CDS features

# Verify that the files are created
ls -l gene.gff cds.gff
