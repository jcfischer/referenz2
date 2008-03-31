require File.join(File.dirname(__FILE__), *%w[.. helper])

with_steps_for :login, :navigation, :pages, :webrat do
  Dir["#{File.dirname(__FILE__)}/*_story"].each do |file|
    run file, :type => RailsStory if File.file?(file)
  end
end