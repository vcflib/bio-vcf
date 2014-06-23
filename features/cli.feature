@cli
Feature: Command-line interface (CLI)

  bio-vcf has a powerful command line interface. Here we regression test features.

  Scenario: Test the info filter using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --filter 'r.info.dp>100'"
    Then I expect the named output to match the named output "r.info.dp"

  Scenario: Test the info filter using dp and threads
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --num-threads 4 --filter 'r.info.dp>2'"
    Then I expect the named output to match the named output "thread4"

  Scenario: Test the info filter using dp and threads with lines
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --num-threads 4 --thread-lines 4 --filter 'r.info.dp>2'"
    Then I expect the named output to match the named output "thread4_4"

  Scenario: Test the sample filter using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --sfilter 's.dp>20'"
    Then I expect the named output to match the named output "s.dp"

  Scenario: Test the info eval using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --eval 'r.info.dp'"
    Then I expect the named output to match the named output "eval_r.info.dp"

  Scenario: Test the sample eval using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --seval 's.dp'"
    Then I expect the named output to match the named output "seval_s.dp"

  Scenario: Test the sample filter + eval using dp
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf -i --sfilter 's.dp>10' --seval 's.dp'"
    Then I expect the named output to match the named output "sfilter_seval_s.dp"


  Scenario: Rewrite an info field
    Given I have input file(s) named "test/data/input/multisample.vcf"
    When I execute "./bin/bio-vcf --rewrite rec.info[\'sample\']=\'XXXXX\'"
    Then I expect the named output to match the named output "rewrite.info.sample"

  

