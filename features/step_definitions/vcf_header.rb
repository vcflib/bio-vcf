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

Then(/^I expect vcf\.filedate to be "(.*?)"$/) do |arg1|
  end

Then(/^I expect vcf\['fileDate'\] to be "(.*?)"$/) do |arg1|
end

Then(/^I expect vcf\.phasing to be "(.*?)"$/) do |arg1|
end

Then(/^I expect vcf\.reference to be "(.*?)"$/) do |arg1|
end

Then(/^I expect vcf\.format\['GT'\] to be \{ 'ID' => 'GT', 'Number' => '(\d+)', 'Type' => 'String', 'Description' => 'Genotype' \}$/) do |arg1|
end

Then(/^I expect vcf\.format\['DP'\] to be \{ 'ID' => 'DP', 'Number' => '(\d+)', 'Type' => 'Integer', 'Description' => 'Total read depth' \}$/) do |arg1|
end

Then(/^I expect vcf\.format\['DP(\d+)'\] to be \{ 'ID' => 'DP(\d+)', 'Number' => '(\d+)', 'Type' => 'Integer', 'Description' => '\# high\-quality ref\-forward bases, ref\-reverse, alt\-forward and alt\-reverse bases' \}$/) do |arg1, arg2, arg3|
end

Then(/^I expect vcf\.info\['PM'\] to be \{'ID' => 'PM', 'Number' => '(\d+)', 'Type' => 'Flag', 'Description' => 'Variant is Precious\(Clinical,Pubmed Cited\)'$/) do |arg1|
  pending "yes"
end
