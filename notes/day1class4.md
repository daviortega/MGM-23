# Sequence Assembly Overview
*by Bill Anderopoulos*


## Terminology

Read: Sequenced

Plant's genoems might be bigger than the human genome.




## Intro to short-read Assembly

de bruijn example

all vs all assemblers fails

STEP 1: Kmers

STEP 2: build de-bruijn graph from the Kmers

STEP 3: simplify the graph as much as possible

k=3 won't work... charles dickson (IT was the best of times...)
k = 20 work

can't use largest k possible: sequence errors.

STEP 4: convert graph to fasta

## practice
hight GC content i bad

metagenomes:
- one organism is more abundant than others.
- won't be able to assemble less abundant

## PacBio

difference from illumina:
fragments 270 vs. 10k fragment bases.

error is random in the genome. Errors can be corrected by increasing the coverage: sequencing multiple times or alignments.

## HGAP for microbial assemblies.


## Illumina is good for

- metagenomics
- single cells
- metatranscriptomes

## DIY

### Questions:

- type of data
- how large
- quality
- bias

### Typical processing
- trim adaptores
- filter contaminants
- examine quality metrics
  - insert size
  - distribution
  - base freq.
  - GC plot


Choose the right assembler - all open source


## Q&A

Falcon vs. HGAP
Falcon developed for diploids
Falcon need to decide which sequence is the main genome and


Emily:
- try different assemblers
- IMG won't accept non-assembled data


## Live Demo




install BBMap, spades and pigz


bbduck
qtrim=r -> quality trim
trimq=8 ->
maxns = 0
minlen = 70
k=31
hdist=1
