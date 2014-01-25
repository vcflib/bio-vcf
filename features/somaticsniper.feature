Feature: VCF for Somatic Sniper

  Here we take a VCF line and parse the information given by Somatic Sniper. 

  At this position the reference contains: AAAGAAAAGAAAAA  (12A,2G)
  At this position the tumor contains:     AAAAACACAA      (8A,2C)

  rec.alt contains variants C,G.  rec.tumor.bcount reflects the contents of the
  tumor (8A,2C) so rec.tumor.bcount[rec.alt] reflects the actual number of
  variants in the tumor. 

  The mapping quality in the BAM file is 37/37 and base quality is 55/60 in normal
  and tumor respectively.

  For the second scenario:

  At this position the reference contains: (15A)
  At this position the tumor contains:     AAAAAAAAATATTA (13A, 3T)

  Scenario: When parsing a record

    Given the somatic sniper vcf line
    """
1       27691244        .       A       C,G     .       .       .       GT:IGT:DP:DP4:BCOUNT:GQ:JGQ:VAQ:BQ:MQ:AMQ:SS:SSC        0/2:0/2:14:0,12,0,2:12,0,2,0:14:35:14:14,35:37:37,37:1:.        0/1:0/1:10:0,8,0,2:8,2,0,0:18:35:18:20,51:37:37,37:2:33
    """
    When I parse the record
    Then I expect rec.chrom to contain "1"
    Then I expect rec.pos to contain 27691244
    Then I expect rec.ref to contain "A"
    And I expect rec.alt to contain ["C","G"]
    And I expect rec.tumor.dp to be 10
    And I expect rec.tumor.dp4 to be [0,8,0,2]
    And I expect rec.tumor.bcount.to_ary to be [8,2,0,0]
    And I expect rec.tumor.bcount[rec.alt] to be [2,0]
    And I expect rec.tumor.bcount["G"] to be 0 
    And I expect rec.tumor.bcount[1] to be 2
    And I expect rec.tumor.bcount[3] to be 0
    And I expect rec.tumor.bcount.sum to be 2
    And I expect rec.tumor.bcount.max to be 2
    And I expect rec.tumor.bq.to_ary to be [20,51]
    And I expect rec.tumor.bq["G"] to be 51
    And I expect rec.tumor.bq[1] to be 51
    And I expect rec.tumor.bq.min to be 20
    And I expect rec.tumor.bq.max to be 51
    And I expect rec.tumor.amq.to_ary to be [37,37]
    And I expect rec.tumor.mq to be 37
    And I expect rec.tumor.ss to be 2

    Given the somatic sniper vcf line
    """
1 27686841  . A T . . . GT:IGT:DP:DP4:BCOUNT:GQ:JGQ:VAQ:BQ:MQ:AMQ:SS:SSC  0/0:0/0:15:3,12,0,0:15,0,0,0:66:37:0:25:37:37:0:. 0/1:0/1:16:2,11,0,3:13,0,0,3:30:37:30:34,55:37:37,37:2:37
    """
    When I parse the record
    Then I expect rec.chrom to contain "1"
    Then I expect rec.pos to contain 27686841
    Then I expect rec.ref to contain "A"
    And I expect rec.alt to contain one ["T"]
    And I expect rec.tumor.dp to be 16
    And I expect rec.tumor.dp4 to be [2,11,0,3]
    And I expect rec.tumor.bcount.to_ary to be [13,0,0,3]
    And I expect rec.tumor.bcount[rec.alt] to be one [3]
    And I expect rec.tumor.bcount["G"] to be 0 
    And I expect rec.tumor.bcount["T"] to be 3
    And I expect rec.tumor.bcount[1] to be 0
    And I expect rec.tumor.bcount[3] to be 3
    And I expect rec.tumor.bcount.sum to be 3
    And I expect rec.tumor.bcount.max to be 3
    And I expect rec.tumor.bq.to_ary to be [34,55]
    And I expect rec.tumor.bq["T"] to be 34
    And I expect rec.tumor.bq[1] to be 55
    And I expect rec.tumor.bq.min to be 34
    And I expect rec.tumor.bq.max to be 55
    And I expect rec.tumor.amq.to_ary to be [37,37]
    And I expect rec.tumor.mq to be 37
    And I expect rec.tumor.ss to be 2

    
