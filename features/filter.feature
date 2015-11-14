@filter
Feature: Adding filters

  bio-vcf can add soft filters. Rather than removing failing items we can
  inject filter state into the FILTER field. To add state such as PASS or
  LowDepth simply use a filter and the --set-filter switch. If a filter already
  has state the new one is appended with a semi-colon.
  
  Scenario: Test the info filter using dp and threads
    Given I have input file(s) named "test/data/input/somaticsniper.vcf"
    When I execute "./bin/bio-vcf --add-filter PASS --filter 'r.normal.dp>5 and r.tumor.dp>7'"
    Then I expect the named output to match the named output "pass1"
