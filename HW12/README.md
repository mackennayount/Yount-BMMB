# Homework 12
*Mackenna Yount*

### Explain how to run the Makefile to produce a VCF file

**Download and index a reference genome**
Using the makefile, you can download a reference genome and then index it using:
```bash
make bam
```

**Align SRA reads to reference genome**
This make command also downloads sequence data (fastq files) from the chosen SRA and aligns the data to the reference genome.

The output of this make command includes the reference genome as a fasta format, both paired end reads, and the bam file. It also runs flagstats of the BAM alignment. 

**Call variants**
Using the makefile, you can call varinats from the alignment file using tools from the bio code toolbox with:
```bash
make vcf
```
This generates a VCF file as an output that can be then visualized in tandem with the BAM file previously generated.

### Collect a set of samples from the SRA database that match my genome and create a design.csv file that lists the samples to be processed.

### Use GNU parallel or any other method of your choice to run the Makefile on all (or a subset) of the samples

I used the following code to run all my samples:
```bash
cat design.csv | parallel --colsep , --header : make all SRR={run_accession} SAMPLE={sample_alias}
```

### Merge the resulting VCF files into a single one
After running the makefile on all the samples, I was able to merge the resulting VCF files into one. This is what it looks like in IGV:
<img width="1440" alt="Screenshot 2024-12-01 at 9 57 49 PM" src="https://github.com/user-attachments/assets/12b40a15-6b39-475a-a964-0d85848b6014">

<img width="1440" alt="Screenshot 2024-12-01 at 9 58 15 PM" src="https://github.com/user-attachments/assets/d9b0843d-1395-492f-b132-ac4646610d92">

### Discuss what you see in your VCF file
My merged vcf file shows that most of the variants in the reads are pretty similar overall, but there are a few differences between samples. In the photo I attached above, you can see some of the differences in the individual VCF files that are included in the merged one. 
