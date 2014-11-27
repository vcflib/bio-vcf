@meta
Feature: Parsing VCF meta information from the header

  Take a header and parse that information as defined by the VCF standard.
  
  Scenario: When parsing a header line

    Given the header lines
    """
##fileformat=VCFv4.1
##fileDate=20140121
##phasing=none
##reference=file:///data/GENOMES/human_GATK_GRCh37/GRCh37_gatk.fasta
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
    """
    When I parse the header
    Then I expect header.fields[0] to contain "CHROM"
    And I expect rec.tumor.dp to be 10

  Scenario: When parsing the header of somatic_sniper.vcf

    Do something
