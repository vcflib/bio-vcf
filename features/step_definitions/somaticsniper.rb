Given(/^the somatic sniper vcf line$/) do |string|
  @fields = VcfLine.parse(string.split(/\s+/).join("\t"))
end

When(/^I parse the record$/) do
  header = VcfHeader.new
  @rec = VcfRecord.new(@fields,header)
end

Then(/^I expect rec\.chrom to contain "(.*?)"$/) do |arg1|
  expect(@rec.chrom).to eq  "1"
end

Then(/^I expect rec\.pos to contain (\d+)$/) do |arg1|
  expect(@rec.pos).to eq arg1.to_i
end

Then(/^I expect rec\.ref to contain "(.*?)"$/) do |arg1|
  expect(@rec.ref).to eq arg1
end

Then(/^I expect rec\.alt to contain \["(.*?)","(.*?)"\]$/) do |arg1, arg2|
  expect(@rec.alt).to eq [arg1,arg2]
end

Then(/^I expect rec\.alt to contain one \["(.*?)"\]$/) do |arg1|
  expect(@rec.alt).to eq [arg1]
end

Then(/^I expect rec\.tumor\.dp to be (\d+)$/) do |arg1|
  expect(@rec.tumor.dp).to eq arg1.to_i
end

Then(/^I expect rec\.tumor\.dp(\d+) to be \[(\d+),(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  expect(@rec.tumor.dp4).to eq [arg2.to_i,arg3.to_i,arg4.to_i,arg5.to_i]
end


Then(/^I expect rec\.tumor\.bcount.to_ary to be \[(\d+),(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(@rec.tumor.bcount.to_ary).to eq [arg1.to_i,arg2.to_i,arg3.to_i,arg4.to_i]
end

Then(/^I expect rec\.tumor\.bcount\[rec\.alt\] to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec.tumor.bcount[@rec.alt]).to eq [arg1.to_i,arg2.to_i]
end

Then(/^I expect rec\.tumor\.bcount\[rec\.alt\] to be one \[(\d+)\]$/) do |arg1|
  expect(@rec.tumor.bcount[@rec.alt]).to eq [arg1.to_i]
end

Then(/^I expect rec\.tumor\.bcount\["(.*?)"\] to be (\d+)$/) do |arg1, arg2|
  expect(@rec.tumor.bcount[arg1]).to eq arg2.to_i
end

Then(/^I expect rec\.tumor\.bcount\[(\d+)\] to be (\d+)$/) do |arg1, arg2|
  expect(@rec.tumor.bcount[arg1.to_i]).to eq arg2.to_i
end

Then(/^I expect rec\.tumor\.bcount\.sum to be (\d+)$/) do |arg1|
  expect(@rec.tumor.bcount.sum).to eq arg1.to_i
end

Then(/^I expect rec\.tumor\.bcount\.max to be (\d+)$/) do |arg1|
  expect(@rec.tumor.bcount.max).to eq arg1.to_i
end


Then(/^I expect rec\.tumor\.bq\.to_ary to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec.tumor.bq.to_ary).to eq [arg1.to_i,arg2.to_i]
end

Then(/^I expect rec\.tumor\.bq\["(.*?)"\] to be (\d+)$/) do |arg1, arg2|
  expect(@rec.tumor.bq[arg1]).to eq arg2.to_i
end

Then(/^I expect rec\.tumor\.bq\[(\d+)\] to be (\d+)$/) do |arg1, arg2|
  expect(@rec.tumor.bq[arg1.to_i]).to eq arg2.to_i
end

Then(/^I expect rec\.tumor\.bq\.min to be (\d+)$/) do |arg1|
  expect(@rec.tumor.bq.min).to eq arg1.to_i
end

Then(/^I expect rec\.tumor\.bq\.max to be (\d+)$/) do |arg1|
  expect(@rec.tumor.bq.max).to eq arg1.to_i
end


Then(/^I expect rec\.tumor\.amq.to_ary to be \[(\d+),(\d+)\]$/) do |arg1, arg2|
  expect(@rec.tumor.amq.to_ary).to eq [arg1.to_i,arg2.to_i]
end

Then(/^I expect rec\.tumor\.mq to be (\d+)$/) do |arg1|
  expect(@rec.tumor.mq).to eq arg1.to_i
end

Then(/^I expect rec\.tumor\.ss to be (\d+)$/) do |arg1|
  expect(@rec.tumor.ss).to eq arg1.to_i
end


