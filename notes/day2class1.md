# Introduction to Functional annotation  and comparative genomics for gene discovery[Live Demo]
*by Rekha Seshadri*

After you find the features, you try to find genes

## Searching databases:
- pairwise
  - BLAST does not work anymore
    - E-value depends on the size of the database. Instead: length of alignment coverage of query sequence and identity.
    - Databases: nr, RefSeq, Uniref
  - Usearch
    - KEGG
- Searching profiles:
  - To make a profile: MSA of seed sequences, manually curated, HMMs, PSSMs
  - mode sensitive than pairwise - detecting distant relationships.
  - RPS-blast, BLAST and Hmmer
  - Dtabases: COG, KOGs, TIGRFAM, Pfam

hmmsearch -> use trusted cutoff

TIGRFAM is not updated anymore.

If matches are bad:
- Gene neighborhood
- Best reciprocal blast hits

globin gene as example of paralogy and orthology

## homology != than function:
- paralogs problems
- multi-domain proteins
- moonlight problems -> template has two functions.

## still no hits:
- gene context
- sub-cellular localization
- topological features
- prediction of binding sites

KEGG is the preferred when searching for functions

## Workflow:
- put the two strains you want to work in the genome comparative



Q&A: bad hit to database (e-value of 1) to a protein that you expect.
