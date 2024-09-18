# Week 3 HW - Lec06
*Mackenna Yount*

GitHub files: https://github.com/mackennayount/Yount-BMMB

# Visualize the GFF file of your choice

I chose to visualize *Listeria monocytogenes* EGD-e and I got the file from NCBI. Then, I loaded the greference enome into IGF as well as the  annotations. After that, I needed to separate just the genes into a new file and do the same with coding sequence regions.

```bash
datasets download genome accession GCF_000196035.1 --include gff3,rna,cds,protein,genome,seq-report
cat genomic.gff | awk ' $3=="gene" { print $0 }' > gene.gff
cat genomic.gff | awk ' $3=="CDS" { print $0 }' > cds.gff
```
I used the translation table for bacterial, archaeal, and plant plasmid. First, I verified that the start codon matched up:

<img width="1440" alt="start-codon" src="https://github.com/user-attachments/assets/f59ccffb-ebc1-410e-bd15-911bc7d9bd07">

Then, I verified that the stop codon also matched up:

<img width="1440" alt="stop-codon" src="https://github.com/user-attachments/assets/8da29b2f-04ca-4632-a362-1a709275416b">

# Creating a manual GFF file

I was not able to use the 'code' command like in the example video, I got the following error:

```bash
code manual.gff
```
```bash
-bash: code: command not found
```

Because of this, I manually created a file (using 'touch') and manually opened it in Visual Studio Code to create the gff file. Once I visualized the final file in IGF, it looked like this:

<img width="1440" alt="manual-gff" src="https://github.com/user-attachments/assets/72a77a82-e52b-490d-a394-1378c84ae4b3">

