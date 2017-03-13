
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "./*_tests.rb"     # This expects your tests to be inside a test subfolder
end                                   # and end with '_test.rb`
# Run all your test files from the terminal with "rake test"