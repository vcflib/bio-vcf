Given(/^the VCF line$/) do |string|
  @header = VcfHeader.new
  @header.add("#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\tSample")
  @vcfline = string
end

When(/^I evaluate '([^']+)'$/) do |arg1|
  # concat VCF line with sample (arg1)
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+[arg1]).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  @g = @rec.sample['Sample']
  p @g
  expect(@g).not_to be nil
  @s = VcfSample::Sample.new(@rec,@g)
  @ignore_missing = false
end

Then(/^I expect s\.empty\? to be false$/) do
  expect(@s.empty?).to be false
  expect(@s.sfilter("s.empty?",do_cache: false)).to be false
end

Then(/^I expect s\.dp\? to be true$/) do
  p ['eval s.dp?',@s.eval("s.dp?",do_cache: false)]
  p ['eval s.dp',@s.eval("s.dp",do_cache: false)]
  p @g.dp
  p @s.dp
  p @s.sfilter("s.dp?",do_cache: false)
  expect(@s.eval("s.dp?",do_cache: false)).to be true
end

Then(/^I expect s\.dp to be (\d+)$/) do |arg1|
  # p @s.eval("s.dp")
  p :now
  p ['eval s.dp?',@s.eval("s.dp?",do_cache: false)]
  p ['eval s.dp',@s.eval("s.dp",do_cache: false)]
  expect(@s.eval("s.dp",do_cache: false)).to equal arg1.to_i
end

Then(/^sfilter 's\.dp>(\d+)' to be true$/) do |arg1|
  expect(@s.sfilter("dp>#{arg1}",do_cache: false)).to be true
end

When(/^I evaluate missing '([^']+)'$/) do |arg1|
  # concat VCF line with sample (arg1)
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+[arg1]).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  @g = @rec.sample['Sample']
  @s = VcfSample::Sample.new(@rec,@g)
  p @s
  expect(@s).not_to be nil
  @ignore_missing = false
end

Then(/^I expect s\.dp\? to be false$/) do
  expect(@s.eval("s.dp?",do_cache: false)).to be false
end

Then(/^I expect s\.dp to be nil$/) do
  expect(@s.eval("s.dp",ignore_missing_data: @ignore_missing, do_cache: false)).to be nil 
end

Then(/^sfilter 's\.dp>(\d+)' to throw an error$/) do |arg1|
  expect { @s.eval("s.dp>#{arg1}",do_cache: false) }.to raise_error NoMethodError
end

Then(/^sfilter 's\.dp>(\d+)' to be false$/) do |arg1|
   expect(@s.sfilter("s.dp>#{arg1}",ignore_missing_data: @ignore_missing, do_cache: false)).to be false
end

When(/^I evaluate empty '\.\/\.'$/) do
  # concat VCF line with sample (arg1)
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+['./.']).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  @g = @rec.sample['Sample']
  @s = VcfSample::Sample.new(@rec,@g)
  p @s
  expect(@s).not_to be nil
  @ignore_missing = false
end

When(/^I evaluate missing '([^']+)' with ignore missing$/) do |arg1|
  # concat VCF line with sample (arg1)
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+[arg1]).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  @g = @rec.sample['Sample']
  @s = VcfSample::Sample.new(@rec,@g)
  p @s
  expect(@s).not_to be nil
  @ignore_missing = true
end

Then(/^I expect s\.empty\? to be true$/) do
  expect(@s.sfilter("s.empty?",do_cache: false)).to be true
end

Then(/^I expect s\.dp to throw an error$/) do
  @s.instance_eval { undef :dp }
  p @s.eval("s.dp",do_cache: false)
  expect { @s.eval("s.dp",do_cache: false) }.to raise_error NoMethodError
end

When(/^I evaluate empty '\.\/\.' with ignore missing$/) do
  # concat VCF line with sample (arg1)
  @fields = VcfLine.parse((@vcfline.split(/\s+/)+['./.']).join("\t"))
  @rec = VcfRecord.new(@fields,@header)
  p @rec
  @g = @rec.sample['Sample']
  @s = VcfSample::Sample.new(@rec,@g)
  p @s
  expect(@s).not_to be nil
  @ignore_missing = true
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


