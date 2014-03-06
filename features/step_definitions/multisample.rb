Given(/^the multi sample header line$/) do |string|
  @header = VcfHeader.new
  @header.add(string)
end

When(/^I parse the header$/) do
  expect(@header.column_names.size).to eq 16
  expect(@header.samples.size).to eq 7
  expect(@header.samples).to eq ["BIOPSY17513D", "clone10", "clone3", "clone4", "subclone105", "subclone33", "subclone46"]
end

Given(/^multisample vcf line$/) do |string|
  @fields = VcfLine.parse(string.split(/\s+/).join("\t"))
  @rec1 = VcfRecord.new(@fields,@header)
end

Then(/^I expect multisample rec\.alt to contain \["(.*?)"\]$/) do |arg1|
  expect(@rec1.alt).to eq ["T"]
end

Then(/^I expect rec\.qual to be (\d+)\.(\d+)$/) do |arg1, arg2|
  expect(@rec1.qual).to eq 106.3
end

Then(/^I expect rec\.info\.ac to be (\d+)$/) do |arg1|
  expect(@rec1.info.ac).to eq arg1.to_i
end
Then(/^I expect rec\.info\.af to be (\d+)\.(\d+)$/) do |arg1, arg2|
  expect(@rec1.info.af).to eq 0.357
end

Then(/^I expect rec\.info\.dp to be (\d+)$/) do |arg1|
  expect(@rec1.info.dp).to eq 1537
end

Then(/^I expect rec\.info\.readposranksum to be (\d+)\.(\d+)$/) do |arg1, arg2|
  expect(@rec1.info.readposranksum).to eq 0.815
end

Then(/^I expect rec\.sample\['BIOPSY(\d+)D'\]\.gt to be "(.*?)"$/) do |arg1, arg2|
  # p @rec1.sample
  expect(@rec1.sample['BIOPSY17513D'].gt).to eq "0/1"
end

Then(/^I expect rec\.sample\['BIOPSY(\d+)D'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  expect(@rec1.sample['BIOPSY17513D'].ad).to eq [189,25]
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  expect(@rec1.sample['subclone46'].ad).to eq [167,26]
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.dp to be (\d+)$/) do |arg1, arg2|
  expect(@rec1.sample['subclone46'].dp).to eq 196
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.gq to be (\d+)$/) do |arg1, arg2|
  expect(@rec1.sample['subclone46'].gq).to eq 20 
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(@rec1.sample['subclone46'].pl).to eq [20,0,522]
end

Then(/^I expect rec\.sample\.biopsy(\d+)d\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  expect(@rec1.sample.biopsy17513d.gt).to eq "0/1"
end

Then(/^I expect rec\.sample\.subclone(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(@rec1.sample.subclone46.pl).to eq [20,0,522]
end

Then(/^I expect rec\.biopsy(\d+)d\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  expect(@rec1.biopsy17513d.gt).to eq "0/1"
end

Then(/^I expect rec\.subclone(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(@rec1.subclone46.pl).to eq [20,0,522]
end

