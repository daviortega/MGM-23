##MGM Assembly live demo shell script
##Brian Bushnell (bbushnell@lbl.gov)
##September 25, 2016


##***** Setup *****


##First make a new directory and copy or link your raw reads to it.
##In this case the data is a single-cell library for Clostridium fallax DSM 2631

mkdir example
cd example
ln -s /global/projectb/scratch/bushnell/mgm/10711.5.175734.TCGCTGT-AACAGCG.fastq.gz raw.fq.gz


##On Genepool at JGI, you can load installed software like this:

#module load bbtools
module load spades/3.9.0
module load pigz


##Otherwise, download and install the bbtools package and add it to your path.  For example:

wget http://downloads.sourceforge.net/project/bbmap/BBMap_36.32.tar.gz
tar -xzf BBMap_36.32.tar.gz
#ln -s bbmap/*.sh .
PATH=$PATH:bbmap

##Also fetch any necessary references for filtering and link them to the current directory.
##In this case I am using a masked version of the human genome which is available for download from JGI.
##It's also here: https://drive.google.com/open?id=0B3llHR93L14wd0pSSnFULUlhcUk

ln -s /global/projectb/sandbox/gaag/bbtools/hg194/hg19_main_mask_ribo_animal_allplant_allfungus.fa.gz human.fa.gz


##If your reads are paired in two files, you can convert them to interleaved format for convenience:

#reformat.sh in=r1.fq.gz in2=r2.fq.gz out=raw.fq.gz


##BBTools is available here: https://sourceforge.net/projects/bbmap/
##SPAdes is available here: http://bioinf.spbau.ru/spades
##Megahit is available here: https://github.com/voutcn/megahit
##Quast is available here: http://quast.sourceforge.net/quast


##***** Filtering and Trimming *****


##Trim adapters.  This can use adapters.fa included with BBMap or custom adapters.  You can alternatively discover the actual adapter sequence with BBMerge if you want.

bbduk.sh in=raw.fq.gz out=trimmed.fq.gz ktrim=r minlen=70 k=23 mink=11 hdist=1 tbo tpe ftm=5 ref=bbmap/resources/adapters.fa ow


##Perform quality-trimming/filtering, and filtering of PhiX and other and small, synthetic contaminant removal.
 
bbduk.sh in=trimmed.fq.gz out=filtered.fq.gz qtrim=r trimq=8 maxns=0 minlen=70 k=31 hdist=1 ref=bbmap/resources/sequencing_artifacts.fa.gz,bbmap/resources/phix174_ill.ref.fa.gz ow


##Remove reads that map to a masked version of known sources of contamination, such as the human genome.
##Note that there are a lot of extra parameters that increase the specificity, to eliminate false-positive removals.

bbmap.sh in=filtered.fq.gz outu=clean.fq.gz ref=human.fa.gz usemodulo ow qtrim=rl trimq=10 untrim kfilter=25 maxsites=1 tipsearch=0 minratio=.9 maxindel=3 minhits=2 bw=12 bwr=0.16 fast maxsites2=10 nodisk


##***** Error Correction and Normalization *****


##Error-correct reads 

bbmerge.sh in=clean.fq.gz out=ecco.fq.gz ecco mix strict adapters=default
tadpole.sh in=ecco.fq.gz out=ecct.fq.gz ecc ow


##Normalize reads.  Only appropriate for certain circumstances, like very high and spiky coverage.
##In this example normalization has little effect on assembly metrics, and is skipped.

#bbnorm.sh in=ecct.fq.gz out=normalized.fq.gz target=100 min=3 ow


##***** Read Extension and Merging *****


##Merge reads.  "rem" also does extension and is optional.

bbmerge.sh in=ecct.fq.gz outm=merged.fq.gz outu=unmerged.fq.gz rem k=62 ow adapters=default


##***** Assembly *****


##For multi-kmer assemblers, the choice of K is not too important.
##For a single-kmer assembler, K is very important.  The optimal value was determined to be 40 for this data.
##You can estimate the optimal kmer length like this:

#tadwrapper.sh in=merged.fq.gz,unmerged.fq.gz out=temp%.fa delete k=25,62,93 bisect extend


##Assemble with Spades (for bacterial single cells, isolates, and small/low-complexity metagenomes):

spades.py --only-assembler -k25,55,95,125 --phred-offset 33 -s merged.fq.gz --12 unmerged.fq.gz -o sp_out 1>sp.o 2>&1 &


##Assemble with Megahit (for large/complex metagenomes):

#megahit --k-min 31 --k-max 127 --k-step 24 --12 ecco.fq.gz -o mh_out 1>mh.o 2>&1 &


##Assemble with Tadpole (for high speed, high accuracy, but lower contiguity):

tadpole.sh in=merged.fq.gz,unmerged.fq.gz out=asmTad.fa k=40 mce=1 ow


##Note:
##In my testing Megahit does better with paired "ecco" reads (error-corrected by overlap only).
##SPAdes and Tadpole prefer merged, error-corrected reads (corrected using both overlap and kmers).


##*****  Assembly Evaluation  *****


##Basic assembly statistics (N50/L50, etc).
##You can alternatively use statswrapper.sh to compare multiple assemblies.

stats.sh in=asmTad.fa


##Advanced assembly statistics, including gene prediction.
##This is slow, but is very useful when you have a reference, in which case Quast will report misassembly counts and genome completeness.

#quast.py -o quastout -f -t 32 *.fa


