Given(/^the multi sample header line$/) do |string|
  @header = VcfHeader.new
  @header.add(string)
end

When(/^I parse the header$/) do
  expect(@header.column_names.size).to eq 16
  expect(@header.samples.size).to eq 7
  expect(@header.samples).to eq ["Original", "s1t1", "s2t1", "s3t1", "s1t2", "s2t2", "s3t2"]
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

Then(/^I expect rec\.sample\['Original'\]\.gt to be "(.*?)"$/) do |arg1|
  expect(@rec1.sample['BIOPSY17513D'].gt).to eq "0/1"
end

Then(/^I expect rec\.sample\['Original'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.sample['BIOPSY17513D'].ad).to eq "0/1"
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['Original'\]\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.dp to be (\d+)$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.gq to be (\d+)$/) do |arg1, arg2, arg3|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\.original\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.sample\.s(\d+)t(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.original\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.s(\d+)t(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  pending # express the regexp above with the code you wish you had
end


