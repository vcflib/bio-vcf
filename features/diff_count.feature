@diff

Feature: Variant calling (filters) - diffing nucleotide counts

  Basic filtering happens on the command line with the --filter switch. To
  support somewhat more advanced features the following features are
  included.

  When diffing nucleotide counts we want to find out which nucleotide defines
  the tumor. The difference has to be larger than 0 and the relative difference
  is the max. When a threshold is set only those nucleotides are included which
  pass the threshold (i.e., no more than x supporting nucleotides in the
  reference). 

  The advantage is that filtering is possible without actually looking at
  the rec.alt and rec.ref values, i.e., no assumptions are being made 
  about the underlying nucleotides.

  Scenario: Diffing nucleotide counts

    Given normal and tumor counts [0,25,0,1] and [0,40,0,12]
    When I look for the difference
    Then I expect the diff to be [0,15,0,11]
    And the relative diff to be [0,0.23,0,0.85]
    And I expect the defining tumor nucleotide to be "T"
    And I expect the tumor count to be 12
    When I set an inclusion threshold for the reference
    Then I expect the diff for threshold 2 to be [0,0,0,11]
    And the relative diff to be [0,0,0,0.85]
   
