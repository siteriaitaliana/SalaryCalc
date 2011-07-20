When /^ I run "([^\"]*)"$/ do |cmd|
  run_interactive(unescape(cmd))
end

Then /^ I should see "(.*)"$/ do |partial_output|
  combined_output.should =~ compile_and_escape(partial_output)
end
