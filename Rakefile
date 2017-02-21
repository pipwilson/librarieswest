#!/usr/bin/env rake

require 'rake/testtask'
require 'dotenv/tasks'

task test: :dotenv do
    Rake::TestTask.new do |t|
        t.test_files = FileList['tests/*_test.rb']
    end
end
