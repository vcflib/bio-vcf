@sfilter
Feature: Sample filters

  Bio-vcf supports sample filters, where every sample is evaluated
  independently, though they have the rec information (chrom, pos, info)
  available.

  Scenario: Example of a sample
  
    Given the VCF line
    """
1 10723 . C G 73.85 . AC=4;AF=0.667;AN=6;BaseQRankSum=1.300;DP=18;Dels=0.00;FS=3.680;HaplotypeScore=0.0000;MLEAC=4;MLEAF=0.667;MQ=20.49;MQ0=11;MQRankSum=1.754;QD=8.21;ReadPosRankSum=0.000 GT:AD:DP:GQ:PL
    """
    When I evaluate '0/0:6,0:6:3:0,3,33'
    Then I expect s.empty? to be false
    Then I expect s.dp? to be true
    Then I expect s.dp to be 6
    And sfilter 's.dp>4' to be true

  # Scenario: Sample with missing data
    When I evaluate missing '0/0:6,0:.:3:0,3,33'
    Then I expect s.empty? to be false
    Then I expect s.dp? to be false
    Then I expect s.dp to be nil
    And sfilter 's.dp>4' to throw an error

  # Scenario: Sample with missing data with ignore missing set
    When I evaluate missing '0/0:6,0:.:3:0,3,33' with ignore missing
    Then I expect s.empty? to be false
    Then I expect s.dp? to be false
    Then I expect s.dp to be nil
    And sfilter 's.dp>4' to be false

  # Scenario: Missing sample
    When I evaluate empty './.'
    Then I expect s.empty? to be true
    Then I expect s.dp? to be false
    Then I expect s.dp to be nil
    And sfilter 's.dp>4' to throw an error

  # Scenario: Missing sample with ignore missing set
    When I evaluate empty './.' with ignore missing
    Then I expect s.empty? to be true
    Then I expect s.dp? to be false
    Then I expect s.dp to be nil
    And sfilter 's.dp>4' to be false

  # Scenario: Wrong field name in sample
    When I evaluate '0/0:6,0:6:3:0,3,33'
    Then I expect s.empty? to be false
    Then I expect s.dp? to be true
    Then I expect s.what? to throw an error
    And I expect s.what to throw an error

  # Scenario: Get other information for a sample
    When I evaluate '0/0:6,0:6:3:0,3,33'
    Then I expect r.chrom to be "1"
    And I expect r.alt to be ["G"]
    And I expect r.info.af to be 0.667

