# Install the templates
require 'rails_generator'
options = { :collision => :skip }
Rails::Generator::Base.instance('goldspike', [], options).command('create').invoke!