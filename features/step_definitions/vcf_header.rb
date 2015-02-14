Given(/^the VCF header lines$/) do |string|
  header = VcfHeader.new
  header.add string
  @vcf = header
end

When(/^I parse the VCF header$/) do
end

Then(/^I expect vcf\.columns to be \[CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','NORMAL','TUMOR'\]$/) do
  expect(@vcf.column_names).to eq ['CHROM','POS','ID','REF','ALT','QUAL','FILTER','INFO','FORMAT','NORMAL','TUMOR']
end

Then(/^I expect vcf\.fileformat to be "(.*?)"$/) do |arg1|
  expect(@vcf.fileformat).to eq arg1
end

Then(/^I expect vcf\.fileDate to be "(.*?)"$/) do |arg1|
  expect(@vcf.fileDate).to eq arg1
end

Then(/^I expect vcf.field\['fileDate'\] to be "(.*?)"$/) do |arg1|
  expect(@vcf.field['fileDate']).to eq arg1
end

Then(/^I expect vcf\.phasing to be "(.*?)"$/) do |arg1|
  expect(@vcf.phasing).to eq arg1
end

Then(/^I expect vcf\.reference to be "(.*?)"$/) do |arg1|
  expect(@vcf.reference).to eq arg1
end

Then(/^I expect vcf\.format\['(\w+)'\] to be (\{[^}]+\})/) do |arg1,arg2|
  expect(@vcf.format[arg1].to_s).to eq arg2
end

Then(/^I expect vcf\.info\['(\w+)'\] to be (\{[^}]+\})/) do |arg1,arg2|
  expect(@vcf.info[arg1].to_s).to eq arg2
end

Then(/^I expect vcf\.meta to contain all header meta information$/) do
  m = @vcf.meta
  expect(m['fileformat']).to eq "VCFv4.1"
  expect(m['FORMAT']['DP']['Number']).to eq "1"
  expect(m.size).to be 7
end

