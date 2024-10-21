# HW 8
*Mackenna Yount*

### Change previous HW makefile to include rules for aligning reads to a reference genome. 

Add new targets:
* index - create an index for the reference genome
* align - align the reads to the reference genome

See HW8.mk for the code.

### Visualize the resulting BAM files for your simulated reads and for the reads downloaded from SRA

![alt text](<Screenshot 2024-10-20 at 8.23.39 PM.png>)

using samtools flagstat on the BAM file, it outputs the following BAM stats:
``` {bash}
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

I noted from visualizing the BAM file in IGV that there is not a lot of data available and there is a lot less information than the BAM file in the class example. 

![alt text](<Screenshot 2024-10-20 at 8.50.29 PM.png>)