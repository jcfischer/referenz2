
war_file 'helloworld'
compile_ruby true
add_gem_dependencies false
keep_source false

libraries = 
{
  'bsf' => {:version => '2.2.1', :locations => 'http://www.google.it'}
}

for lib_name,lib_props in libraries
  include_library lib_name , :version => lib_props[:version], :locations => lib_props[:locations]
end

