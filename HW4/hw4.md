# Homework 4
*Mackenna Yount*

## Part 1: Write a Script

I created a bash script of my previous assignment. I tried to run it on other peoples data, but I ran into issues because we used different methods to download our data. I downloaded directly from the acession number while others downloaded from a URL. 

I did confirm that the script worked on my own data. I downloaded the data from the acession number and then ran the script. The script produced the correct output. 

The script is as follows and can also be found in my github repository.

```bash
# ------ All the actions follow ------

# Download data by acession from NCBI and make sure all necessary files are included
datasets download genome accession GCF_000196035.1 --include gff3,rna,cds,protein,genome,seq-report

# Unzip the dataset
unzip ncbi_dataset.zip

# Open and view the dataset
cat ncbi_dataset/data/GCF_000196035.1/genomic.gff | head

# Remove all lines beginning with # and save to a new file
cat ncbi_dataset/data/GCF_000196035.1/genomic.gff | grep -v '^#' > mydata.gff

# Separate gene and CDS features into diffeent files
cat mydata.gff | awk ' $3=="gene" { print $0 }' > gene.gff
cat mydata.gff | awk ' $3=="CDS" { print $0 }' > cds.gff

# These two files will be used in IGV to visualize the gene and CDS features

# Verify that the files are created
ls -l gene.gff cds.gff
```

My end goal of my bash script is to create two files with just the gene feeatures and just the CDS features of the *Listeria monocytogenes* genome. To show that the script works, I made it list the files that were created in the script.

## Part 2: Make Use of Ontologies

### Sequence Ontology:

Feature: cds

Definition: "A contiguous sequence which begins with, and includes a start codon and ends with, and includes, a stop codon.

Parent term: mrna_region

Children nodes:
* polypeptide (derives_from)
* cds_region (part of)
* edited_cds
* cds_fragment
* transposable_element_cds
* cds_extension
* cds_independently_known
* cds_predicted

CDS are coding sequences in mRNA, so the parent term of mRNA makes sense. These sequeces determine the makeup of the proteins that they are coding for.All of the children nodes are sub-types of CDS, usually the different parts of the CDS.

### Gene Ontology:

I used a combination ofAmiGO and the bio package to find the GO terms of my choice.

**CC Term - GO:0043190 - four-way junction DNA binding**
* **definition:** "Binding to a DNA segment containing four-way junctions, also known as Holliday junctions, a structure where two DNA double strands are held together by reciprocal exchange of two of the four strands, one strand each from the two original helices."
* **parent term:** dna secondary structure binding
* **children terms:** open form four-way junction dna binding, crossed form four-way junction dna binding
* **genes annotated with this term:** many, including zurM, cbiQ, and gbuC
* **discussion:** This term is pretty speciifc, when I filtered for it I got around 30 hits. It is a specific type of DNA binding, and some of the genes were part of multi-gene complexes so this number is resonable. I think that this GO term is in the middle of the road in terms of specificity. 

**MF Term - GO:0003677 - DNA binding**
* **definition:** "Any molecular function by which a gene product interactsselectively and non-covalently with DNA (deoxyribonucleicacid)."
* **parent term:** nucleic acid binding
* **children terms:** (There are a lot so I will just name a few) - dna template activity, damaged dna binding, recombination hotsport binding, dna translocase activity (has_part), etc.
* **genes annotated with this term:** many, including sbcD, lmo1644, and ccpA
* **discussion:** There were a lot of genes annotated with this GO term, when I filtered for just this term, I got 389 hits. This is a very broad GO term though, as it also has many children terms, so this high number makes sense. 

**BP Term - GO:0007155 - cell adhesion**
* **definition:** "The attachment of a cell, either to another cell or to an underlying substrate such as the extracellular matrix, via cell adhesion molecules."
* **parent terms:** cellular process, biological adhesion
* **children terms:** cell adhesion involved in retrograde extension, negative regulation of cell adhesion (negatively_regulates), cell-substrate adhesion, cell adhesion mediated by integrin, positive regulation of cell adhesion (positively_regulates), cell adhesion involved in heart morphogenesis, cell-cell adhesion, cell adhesion mediator activity (part_of), cell adhesion involved in sprouting angiogenesis
* **genes annotated with this term:** lmo1671
* **discussion:** I wanted to use the GO term for biofilm matrices for this assignment as this is what I research, but as of yet there are no genes annotated with this term so this was the next best thing. I think that this contributes to how specific this term is, as there is only one gene annotated with it. 