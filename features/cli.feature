@cli
Feature: Command-line interface (CLI)

  bio-vcf has a powerful command line interface. Here we regression test features.

  Scenario: Test the sample filter using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --sfilter 's.dp>20'"
    Then I expect the named output to match the named output "sfilter001"

