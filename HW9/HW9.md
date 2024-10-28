# Homework 9
*Mackenna Yount*

### How many reads did not align with the reference genome?

using
```bash
samtools view -c -q 1 -F 4 -F 51 align.bam
```
0 reads

### How many primary, secondary, and supplementary alignments are in the BAM file?

using
```bash
samtools flagstat align.bam
```
20000 primary, zero secondary, and 81 supplementary

### How many properly paired alignments on the reverse strand are formed by reads contained in the first pair (read1) file?

using
```bash
samtools view -c -q 10 -f 2 align.bam
```
18068

I am unsure if this is the correct way to get this information.

### Make a new BAM file that contains only the properly paired primary alignments with a mapping quality over 10.

using 
``` bash
samtools view -q 10 -f 2 -b align.bam > quality.bam && samtools index quality.bam
```

### Compare flagstats for your original and your filtered BAM file. 

original flag stats
```bash
20081 + 0 in total (QC-passed reads + QC-failed reads)
20000 + 0 primary
0 + 0 secondary
81 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
18538 + 0 mapped (92.32% : N/A)
18457 + 0 primary mapped (92.29% : N/A)
20000 + 0 paired in sequencing
10000 + 0 read1
10000 + 0 read2
18258 + 0 properly paired (91.29% : N/A)
18338 + 0 with itself and mate mapped
119 + 0 singletons (0.60% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```

filtered
```bash
18068 + 0 in total (QC-passed reads + QC-failed reads)
18006 + 0 primary
0 + 0 secondary
62 + 0 supplementary
0 + 0 duplicates
0 + 0 primary duplicates
18068 + 0 mapped (100.00% : N/A)
18006 + 0 primary mapped (100.00% : N/A)
18006 + 0 paired in sequencing
9005 + 0 read1
9001 + 0 read2
18006 + 0 properly paired (100.00% : N/A)
18006 + 0 with itself and mate mapped
0 + 0 singletons (0.00% : N/A)
0 + 0 with mate mapped to a different chr
0 + 0 with mate mapped to a different chr (mapQ>=5)
```