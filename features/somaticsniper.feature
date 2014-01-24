Feature: VCF for Somatic Sniper

  Scenario: When parsing a record
    Given the somatic sniper vcf line
    """
1       27691244        .       A       C,G     .       .       .       GT:IGT:DP:DP4:BCOUNT:GQ:JGQ:VAQ:BQ:MQ:AMQ:SS:SSC        0/2:0/2:14:0,12,0,2:12,0,2,0:14:35:14:14,35:37:37,37:1:.        0/1:0/1:10:0,8,0,2:8,2,0,0:18:35:18:20,51:37:37,37:2:33
    """
    When I parse the record
    Then I expect rec.chrom to contain "A"
    Then I expect rec.pos to contain "A"
    Then I expect rec.ref to contain "A"
    And I expect rec.alt to contain ["C","G"]
    And I expect rec.tumor.dp to be 10
    And I expect rec.tumor.dp4 to be [0,8,0,2]
    And I expect rec.tumor.bcount to be [8,2,0,0]
    And I expect rec.tumor.bcount[rec.alt] to be [8,2]
    And I expect rec.tumor.dp[rec.alt].sum to be 10
    And I expect rec.tumor.dp[rec.alt].max to be 8
    And I expect rec.tumor.bq to be [20,51]
    And I expect rec.tumor.bq.max to be 51
    And I expect rec.tumor.amq to be [37,37]
    And I expect rec.tumor.mq to be 37
    And I expect rec.tumor.ss to be 2
