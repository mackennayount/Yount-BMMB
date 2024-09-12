# Lecture 3 HW
*Mackenna Yount*

**QUESTION 1:** Tell us a bit about the organism.

The organism is Anas zonorhyncha, which is more commonly known as the Eastern Spot-Billed Duck.

**QUESTION 2:** How many features does the file contain?

```bash
wget http://ftp.ensembl.org/pub/current_gff3/anas_zonorhyncha/Anas_zonorhyncha.ASM222487v1.112.abinitio.gff3.gz
unzip http://ftp.ensembl.org/pub/current_gff3/anas_zonorhyncha/Anas_zonorhyncha.ASM222487v1.112.abinitio.gff3.gz
```

Then I removed all lines beginning with # and saved to a new file

```bash
cat Anas_zonorhyncha.ASM222487v1.112.abinitio.gff3 | grep -v '#' > anas.gff3
```
And it returned:
```bash
NOIK01000001.1	ASM222487v1	region	1	25320044	.	.	ID=region:NOIK01000001.1;Alias=scaffold1
NOIK01000001.1	ensembl	mRNA	74	6837	.	+	.	ID=transcript:47404;Name=GENSCAN00000047404;version=1
NOIK01000001.1	ensembl	exon	74	172	.	+	.	Parent=transcript:47404;Name=361260;exon_id=361260;version=1
NOIK01000001.1	ensembl	exon	6631	6837	.	+	.	Parent=transcript:47404;Name=361261;exon_id=361261;version=1
NOIK01000001.1	ensembl	mRNA	137524	243679	.	+	.	ID=transcript:47403;Name=GENSCAN00000047403;version=1
NOIK01000001.1	ensembl	exon	137524	137843	.	+	.	Parent=transcript:47403;Name=361254;exon_id=361254;version=1
NOIK01000001.1	ensembl	exon	176066	176098	.	+	.	Parent=transcript:47403;Name=361255;exon_id=361255;version=1
NOIK01000001.1	ensembl	exon	188824	189010	.	+	.	Parent=transcript:47403;Name=361256;exon_id=361256;version=1
NOIK01000001.1	ensembl	exon	220838	221178	.	+	.	Parent=transcript:47403;Name=361257;exon_id=361257;version=1
NOIK01000001.1	ensembl	exon	221672	221735	.	+	.	Parent=transcript:47403;Name=361258;exon_id=361258;version=1
```
To list the number of features, I need to isolate column three. From there, I can sort and count duplicate values (features).
```bash
cat anas.gff3 | cut -f 3 | head
cat anas.gff3 | cut -f 3 | sort | uniq -c | head
```
Which returns:
```bash
379372 exon
54035 mRNA
20089 region
```
This means that there are **three features**: exon, mRNA, and region.

**QUESTION 3:** How many sequence regions (chromosomes) does the file contain?

Going back to the origial gff3 file, I could search for sequence regions and count the number of lines.

```bash
cat Anas_zonorhyncha.ASM222487v1.112.abinitio.gff3 | grep '##sequence-region' | wc -l
```
Which returns
```bash
20089
```
So, there are **20089 sequence regions**, which is very fragmented like the example in the demo video.

**QUESTION 4:** How many genes are listed for this organism?

Going back to question 2 where I listed the features of the file, only exon, mRNA, and region were listed. This means that there are **zero genes listed for this organism**.

**QUESTION 5:** What are the top-ten most annotated feature types (column 3) across the genome?

We can have the code output the same information as in question 2. The second sort command is to make sure that the feature types are in order of most to least frequent.
```bash
cat anas.gff3 |cut -f 3 | sort | uniq -c | sort -rn | head
```
Which returns
```bash
379372 exon
54035 mRNA
20089 region
```
Since there are only three feature types, this is the best I've got.

**QUESTION 6:** Having analyzed this GFF file, does it seem like a complete and well-annotated organism?

No it does not, there are no genes annotated in this file. It is mostly exons, which are regions of the genome that will become part of mRNA, but they do not always code.

**QUESTION 7:** Share any other insights you might note.

I think it is interesting that there are no genes in this "gene annotation" file, I wonder why that is.