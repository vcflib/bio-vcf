Given(/^the VCF line$/) do |string|
  @header = nil
  @vcfline = string
end

When(/^I evaluate '([^']+)'$/) do |arg1|
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+[arg1]).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
end

Then(/^I expect s\.empty\? to be false$/) do
  p @rec.sample[0]
  expect(@s.empty?).to be false
end


Then(/^I expect s\.dp to be (\d+)$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^sfilter 's\.dp>(\d+)' to be true$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I evaluate missing '(\d+)\/(\d+):(\d+),(\d+):\.:(\d+):(\d+),(\d+),(\d+)'$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.dp to be nil$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^sfilter 's\.dp>(\d+)' to be false$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I evaluate empty '\.\/\.'$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^sfilter 's\.dp>(\d+)' to throw an error$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I evaluate missing '(\d+)\/(\d+):(\d+),(\d+):\.:(\d+):(\d+),(\d+),(\d+)' with ignore missing$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.empty\? to be true$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.dp to throw an error$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^I evaluate empty '\.\/\.' with ignore missing$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.dp\? to be true$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.dp\? to be false$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.what\? to throw an error$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect s\.what to throw an error$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect r\.chrom to be "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect r\.alt to be \["(.*?)"\]$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I expect r\.info\.af to be (\d+)\.(\d+)$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end


