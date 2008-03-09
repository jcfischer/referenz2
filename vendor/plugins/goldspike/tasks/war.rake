#
# Rake tasks for building a war file
#

# aliases for the tasks
task 'create_war' => ['war:standalone:create']
task 'create_war:standalone' => ['war:standalone:create']
task 'create_war:shared' => ['war:shared:create']
task 'war:create' => ['war:standalone:create']
task 'war:standalone' => ['war:standalone:create']
task 'war:shared' => ['war:shared:create']
task 'tmp:war:clean' => ['tmp:war:clear']

task 'war:init' => [:environment] do
  # load the library
  require 'create_war'
  require 'run'
end

desc 'Create a self-contained Java war'
task 'war:standalone:create' => ['war:init'] do
  creator = War::Creator.new
  creator.standalone = true
  creator.create_war_file
end

desc "Assemble the files for a standalone package"
task 'war:standalone:assemble' => ['war:init'] do
  creator = War::Creator.new
  creator.standalone = true
  creator.assemble
end

desc 'Create a war for use on a Java server where JRuby is available'
task 'war:shared:create' => ['war:init'] do
  creator = War::Creator.new
  creator.standalone = false
  creator.create_war_file
end

desc "Clears all files used in the creation of a war"
task 'tmp:war:clear' => ['war:init'] do
  War::Creator.new.clean_war
end

desc "Run the webapp in Jetty"
task 'war:standalone:run' => ['war:standalone:assemble'] do
  War::Runner.new.run_standalone
end