@meta
Feature: Parsing VCF meta information from the header

  Take a header and parse that information as defined by the VCF standard.
  
  Scenario: When parsing a header line

    Given the VCF header lines
    """
##fileformat=VCFv4.1
##fileDate=20140121
##phasing=none
##reference=file:///data/GENOMES/human_GATK_GRCh37/GRCh37_gatk.fasta
##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">
##FORMAT=<ID=DP,Number=1,Type=Integer,Description="Total read depth">
##FORMAT=<ID=DP4,Number=4,Type=Integer,Description="# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases">
##INFO=<ID=PM,Number=0,Type=Flag,Description="Variant is Precious(Clinical,Pubmed Cited)">
#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	NORMAL	TUMOR
    """
    When I parse the VCF header
    Then I expect vcf.columns to be [CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','NORMAL','TUMOR']
    And I expect vcf.fileformat to be "VCFv4.1"
    And I expect vcf.fileDate to be "20140121"
    And I expect vcf.field['fileDate'] to be "20140121"
    And I expect vcf.phasing to be "none"
    And I expect vcf.reference to be "file:///data/GENOMES/human_GATK_GRCh37/GRCh37_gatk.fasta"
    And I expect vcf.format['GT'] to be { 'ID' => 'GT', 'Number' => '1', 'Type' => 'String', 'Description' => 'Genotype' }
    And I expect vcf.format['DP'] to be { 'ID' => 'DP', 'Number' => '1', 'Type' => 'Integer', 'Description' => 'Total read depth' }
    And I expect vcf.format['DP4'] to be { 'ID' => 'DP4', 'Number' => '4', 'Type' => 'Integer', 'Description' => '# high-quality ref-forward bases, ref-reverse, alt-forward and alt-reverse bases' }
    And I expect vcf.info['PM'] to be { 'ID' => 'PM', 'Number' => '0', 'Type' => 'Flag', 'Description' => 'Variant is Precious(Clinical,Pubmed Cited)' }'

  Scenario: When parsing the header of somatic_sniper.vcf

    Do something
