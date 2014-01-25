
Given(/^normal and tumor counts \[(\d+),(\d+),(\d+),(\d+)\] and \[(\d+),(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8|
  @normal = [arg1,arg2,arg3,arg4].map{|i|i.to_i}
  @tumor = [arg5,arg6,arg7,arg8].map{|i|i.to_i}
end

When(/^I look for the difference$/) do
end

Then(/^I expect the diff to be \[(\d+),(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4|
  expect(Variant.diff(@normal,@tumor)).to eq [arg1.to_i,arg2.to_i,arg3.to_i,arg4.to_i]
end

Then(/^the relative diff to be \[(\d+),(\d+)\.(\d+),(\d+),(\d+)\.(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5, arg6|
  res = [arg1.to_f,(arg2+'.'+arg3).to_f,arg4.to_i,(arg5+'.'+arg6).to_f]
  expect(Variant.relative_diff(@normal,@tumor)).to eq res
end

Then(/^I expect the defining tumor nucleotide to be "(.*?)"$/) do |arg1|
  expect(['A','C','G','T'][Variant.index(@normal,@tumor)]).to eq arg1
end

Then(/^I expect the tumor count to be (\d+)$/) do |arg1|
  expect(@tumor[Variant.index(@normal,@tumor)]).to eq arg1.to_i
end

When(/^I set an inclusion threshold for the reference$/) do
end

Then(/^I expect the diff for threshold (\d+) to be \[(\d+),(\d+),(\d+),(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  @t = arg1.to_i
  @t_diff = Variant.threshold_diff(@t,@normal,@tumor) 
  expect(@t_diff).to eq [arg2.to_i,arg3.to_i,arg4.to_i,arg5.to_i]
end

Then(/^the relative diff to be \[(\d+),(\d+),(\d+),(\d+)\.(\d+)\]$/) do |arg1, arg2, arg3, arg4, arg5|
  res = [arg1.to_f,arg2.to_i,arg3.to_i,(arg4+'.'+arg5).to_f]
  expect(Variant.relative_threshold_diff(@t,@normal,@tumor)).to eq res
end


