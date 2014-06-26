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

Then(/^I expect rec\.sample\.original\.gt to be "(.*?)"$/) do |arg1|
  expect(@rec1.sample['Original'].gt).to eq "0/1"
end

Then(/^I expect rec\.original\.gt to be "(.*?)"$/) do |arg1|
  expect(@rec1.original.gt).to eq "0/1"
end

Then(/^I expect rec\.sample\['Original'\]\.gt to be "(.*?)"$/) do |arg1|
  # expect(@rec1.sample['Original'].gt).to eq "0/1"
end

Then(/^I expect rec\.sample\['Original'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.sample['Original'].ad).to eq [189,25]
end

Then(/^I expect rec\.sample\['Original'\]\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.sample['Original'].gt).to eq "0/1"
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.ad to be \[(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(@rec1.sample['s3t2'].ad).to eq [167,26]
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.dp to be (\d+)$/) do |arg1, arg2, arg3|
  expect(@rec1.sample['s3t2'].dp).to eq 196
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.gq to be (\d+)$/) do |arg1, arg2, arg3|
  expect(@rec1.sample['s3t2'].gq).to eq 20
end

Then(/^I expect rec\.sample\['s(\d+)t(\d+)'\]\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  expect(@rec1.sample['s3t2'].pl).to eq [20,0,522]
end

Then(/^I expect rec\.sample\.original\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.sample.original.gt).to eq "0/1"
end

Then(/^I expect rec\.sample\.s(\d+)t(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  expect(@rec1.sample.s3t2.pl).to eq [20,0,522]
end

Then(/^I expect rec\.original\.gt to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.original.gt).to eq "0/1"
end

Then(/^I expect rec\.s(\d+)t(\d+)\.pl to be \[(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  expect(@rec1.s3t2.pl).to eq [20,0,522]
end

Then(/^I expect test rec\.missing_samples\? to be false$/) do
  expect(@rec1.missing_samples?).to be false
end

Then(/^I expect test rec\.original\? to be true$/) do
  expect(@rec1.original?).to be true
end

Then(/^I expect rec\.missing_samples\? to be true$/) do
  expect(@rec1.missing_samples?).to be true
end

Then(/^I expect rec\.original\? to be true$/) do
  expect(@rec1.original?).to be true
end

Given(/^multisample vcf line with missing data$/) do |string|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect rec\.original\? to be false$/) do
  expect(@rec1.original?).to eq false
end

Then(/^I expect rec\.sample\.s(\d+)t(\d+)\? to be false$/) do |arg1, arg2|
  expect(@rec1.sample.s1t1?).to eq false
end

Then(/^I expect rec\.sample\.s(\d+)t(\d+)\? to be true$/) do |arg1, arg2|
  expect(@rec1.sample.s3t2?).to eq true
end

Then(/^I expect rec\.valid\? to be true$/) do
  expect(@rec1.valid?).to eq true
end

Then(/^I expect r\.original\.gt\? to be true$/) do
  expect(@rec1.original.gt?).to be true
end

Then(/^I expect r\.original\? to be true$/) do
  expect(@rec1.original?).to be true
end

Then(/^I expect rec\.original\? to be true$/) do
  expect(@rec1.original?).to be true
end

Then(/^I expect rec\.original\.gt\? to be true$/) do
  expect(@rec1.original.gt?).to be true
end

Then(/^I expect r\.original\.gti\? to be true$/) do
  expect(@rec1.original.gti?).to eq true
end

Then(/^I expect r\.original\.gti to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec1.original.gti).to eq [arg1.to_i,arg2.to_i]
end

Then(/^I expect r\.original\.gti\[(\d+)\] to be (\d+)$/) do |arg1, arg2|
  expect(@rec1.original.gti[arg1.to_i]).to eq arg2.to_i
end

Then(/^I expect r\.original\.gts\? to be true$/) do
  expect(@rec1.original.gts?).to eq true
end

Then(/^I expect r\.original\.gts to be \["(.*?)","(.*?)"\]$/) do |arg1, arg2|
  expect(@rec1.original.gts).to eq [arg1,arg2]
end

Then(/^I expect r\.original\.gts\[(\d+)\] to be "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

