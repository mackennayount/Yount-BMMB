# Week 3 HW - Lec06
*Mackenna Yount*

GitHub files: https://github.com/mackennayount/Yount-BMMB

**Visualize the GFF file of your choice**

I chose to visualize *Listeria monocytogenes* EGD-e and I got the file from NCBI. 

```bash
datasets download genome accession GCF_000196035.1 --include gff3,rna,cds,protein,genome,seq-report
```
I loaded the greference enome into IGF as well as the  annotations. Then I needed to separate just the genes into a new file.

```bash
cat genomic.gff | awk ' $3=="gene" { print $0 }' > gene.gff
```

I did the same with coding sequence regions.

```bash
cat genomic.gff | awk ' $3=="CDS" { print $0 }' > cds.gff
```
I used the translation table for bacterial, archaeal, and plant plasmid. I verified that the start and stop codons matched up. 

**Creating a manuall GFF file

I was not able to use the 'code' command like in the example video, I got the following error:

```bash
code manual.gff
```
```bash
-bash: code: command not found
```

Because of this, I manually created a file (using 'touch') and manually opened it in Visual Studio Code.
