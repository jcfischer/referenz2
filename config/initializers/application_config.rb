# loads the file 'config/application.yml' and stores all variables in
# a globally accessible hash

APPLICATION = YAML.load_file("#{RAILS_ROOT}/config/application.yml")[RAILS_ENV]