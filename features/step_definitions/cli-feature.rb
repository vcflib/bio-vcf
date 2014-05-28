
Given /^I have input file\(s\) named "(.*?)"$/ do |arg1|
  @filenames = arg1.split(/,/)
end

When /^I execute "(.*?)"$/ do |arg1|
  @cmd = arg1 + ' < ' + @filenames[0]
end

Then(/^I expect the named output to match the named output "(.*?)"$/) do |arg1|
  RegressionTest::CliExec::exec(@cmd,arg1,ignore: '##BioVcf=').should be_true
end
