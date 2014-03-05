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
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect multisample rec\.alt to contain \["(.*?)"\]$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.qual to be (\d+)\.(\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.info\.ac to be (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
Then(/^I expect rec\.info\.af to be (\d+)\.(\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.info\.dp to be (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.info\.readposranksup to be (\d+)\.(\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['BIOPSY(\d+)D'\]\.gt to be "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['BIOPSY(\d+)D'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['BIOPSY(\d+)D'\]\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.dp to be (\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.gq to be (\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['subclone(\d+)'\]\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.biopsy(\d+)d\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.subclone(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end


