@multi
Feature: Multi-sample VCF

  Here we take a VCF line and parse the information for multiple named 
  samples

  Scenario: When parsing a record

    Given the multi sample header line
    """
#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  BIOPSY17513D    clone10 clone3  clone4  subclone105     subclone33      subclone46
    """
    When I parse the header
    Given multisample vcf line
    """
1       10321   .       C       T       106.30  .       AC=5;AF=0.357;AN=14;BaseQRankSum=3.045;DP=1537;Dels=0.01;FS=5.835;HaplotypeScore=220.1531;MLEAC=5;MLEAF=0.357;MQ=26.69;MQ0=258;MQRankSum=-4.870;QD=0.10;ReadPosRankSum=0.815    GT:AD:DP:GQ:PL  0/1:189,25:218:30:30,0,810      0/0:219,22:246:24:0,24,593      0/1:218,27:248:34:34,0,1134     0/0:220,22:248:56:0,56,1207     0/1:168,23:193:19:19,0,493      0/1:139,22:164:46:46,0,689      0/1:167,26:196:20:20,0,522    
    """
    When I parse the record
    Then I expect rec.chrom to contain "1"
    Then I expect rec.pos to contain 10321
    Then I expect rec.ref to contain "C"
    And I expect multisample rec.alt to contain ["T"]
    And I expect rec.qual to be 106.30
    And I expect rec.info.ac to be 5
    And I expect rec.info.af to be 0.357
    And I expect rec.info.dp to be 1537
    And I expect rec.info.readposranksum to be 0.815
    And I expect rec.sample['BIOPSY17513D'].gt to be "0/1"
    And I expect rec.sample['BIOPSY17513D'].ad to be [189,25]
    And I expect rec.sample['subclone46'].ad to be [167,26]
    And I expect rec.sample['subclone46'].dp to be 196 
    And I expect rec.sample['subclone46'].gq to be 20
    And I expect rec.sample['subclone46'].pl to be [20,0,522]
    # And the nicer self resolving
    And I expect rec.sample.biopsy17513d.gt to be [0,1]
    And I expect rec.sample.subclone46.pl to be [20,0,522]
    # And the even better
    And I expect rec.biopsy17513d.gt to be [0,1]
    And I expect rec.subclone46.pl to be [20,0,522]
   
