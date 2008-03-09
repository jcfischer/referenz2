require 'test/unit'
require 'new_java_library'

class WarConfigTest < Test::Unit::TestCase
  
  class MockConfig  
    attr_accessor :jruby_home, :local_java_lib, :java_libraries, :local_maven_lib, :remote_maven_home
    def initialize 
      @java_libraries = {}
      @local_java_lib = "C:/Workspace/rails-integration"
      @jruby_home = "C:/jruby"      
      @local_maven_lib = "/home/user/.m2"
      @remote_maven_home = "http://www.ibiblio.org"
    end
    def add_java_library(name,version,location)
      @java_libraries[name] ||= War::JavaLibrary.new(self, name, :versions => version, :locations => location)
      @java_libraries[name].add_location_and_version(version, location)
    end
  end
  
  
  def test_maven_library_versions_string
    identifier = "myidentifier"
    group = 'mygroup'
    versions = "1.0"
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, versions)
    assert_equal 'myidentifier', java_lib.identifier
    assert_equal 'mygroup' , java_lib.group
    assert_equal(1, java_lib.versions.size)
    assert_equal("1.0", java_lib.versions[0])
  end
  
  def test_maven_library_versions_array
    identifier = "myidentifier"
    versions = ["1.0","1.1"]
    group = "mygroup"
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, versions)
    assert_equal("myidentifier",java_lib.identifier)
    assert_equal("mygroup",java_lib.group)
    assert_equal(2, java_lib.versions.size)
    assert_equal("1.0", java_lib.versions[0])
    assert_equal("1.1", java_lib.versions[1])
  end
  
  def test_maven_library_versions_string_and_locations
    identifier = "myidentifier"
    versions = "1.0"
    locations = "pippo"
    group = 'mygroup'
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, versions, :locations => locations)
    assert_equal(1, java_lib.versions.size)
    assert_equal("1.0", java_lib.versions[0])
    assert_equal("mygroup",java_lib.group)
  end
  
  def test_maven_library_versions_array_locations
    puts name
    identifier = "myidentifier"
    versions = ["1.0","1.1"]
    locations = "pippo"
    group = 'mygroup'
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, versions, :locations => locations)
    assert_equal(2, java_lib.versions.size)
    assert_equal("1.0", java_lib.versions[0])
    assert_equal("1.1", java_lib.versions[1])
  end
  
  def test_maven_library_searcheable_locations_version_string_no_location
    identifier = 'jvyaml'
    group = 'jvyaml'
    version = '1.0'
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, version)
    assert "jvyaml", java_lib.identifier 
    assert "jvyaml", java_lib.group
    assert "1.0" , java_lib.versions[0]
    assert_equal(6, java_lib.searcheable_locations.size)
  end
  
  
  def test_maven_library_searcheable_locations_locations_string
    identifier = 'jvyaml'
    group = 'jvyaml'
    version = '1.0'
    java_lib = War::MavenLibrary.new(MockConfig.new, identifier, group, version, :locations => 'http://svn.codehaus.org/jruby/tags/jruby-0_9_2/lib/jvyaml.jar')
    assert java_lib.identifier , "jvyaml"
    assert_equal(7, java_lib.searcheable_locations.size)
  end
  
  def test_maven_library_searchaeble_locations_locations_array
    java_lib = War::MavenLibrary.new(MockConfig.new, 'jvyaml','jvyaml','2.2.1', :locations => ['loc1','loc2'])
    assert java_lib.identifier , "jvyaml"
    assert_equal(8, java_lib.searcheable_locations.size)
  end
  
  def test_maven_library_searchaeble_locations_versions_string
    java_lib = War::MavenLibrary.new(MockConfig.new, 'jvyaml', 'jvyaml',  '0.2.1')
    assert java_lib.identifier , "jvyaml"
    assert_equal(6, java_lib.searcheable_locations.size)
  end
  
  def test_maven_library_searcheable_locations_versions_array_locations_string
    java_lib = War::MavenLibrary.new(MockConfig.new, 'jvyaml','jvyaml', ['0.2.1','0.2.2'], :locations => 'http://svn.codehaus.org/jruby/tags/jruby-0_9_2/lib/jvyaml.jar')
    assert java_lib.identifier , "jvyaml"
    assert_equal(11, java_lib.searcheable_locations.size)
  end
  
  def test_maven_library_searcheable_locations_versions_array_locations_array
    java_lib = War::MavenLibrary.new(MockConfig.new, 'jvyaml', 'jvyaml',  ['0.2.1','0.2.2'], :locations => ['loc1','loc2'])
    assert java_lib.identifier , "jvyaml"
    assert_equal(12, java_lib.searcheable_locations.size)
  end
  
  def test_maven_library_order  
    java_lib = War::MavenLibrary.new(MockConfig.new, 'jvyaml', 'jvyaml',['0.2.1','0.2.2'], :locations => ['loc1','loc2'])
    assert java_lib.identifier , "jvyaml"
    assert_equal(12, java_lib.searcheable_locations.size)
    assert_equal('/home/user/.m2/jvyaml/jvyaml/0.2.1/jvyaml-0.2.1.jar',java_lib.searcheable_locations[0])
    assert_equal('http://www.ibiblio.org/jvyaml/jvyaml/0.2.1/jvyaml-0.2.1.jar',java_lib.searcheable_locations[1])
    assert_equal('/home/user/.m2/jvyaml/jvyaml/0.2.2/jvyaml-0.2.2.jar',java_lib.searcheable_locations[2])
    assert_equal('http://www.ibiblio.org/jvyaml/jvyaml/0.2.2/jvyaml-0.2.2.jar',java_lib.searcheable_locations[3])
    assert_equal('loc1',java_lib.searcheable_locations[4])
    assert_equal('loc2',java_lib.searcheable_locations[5])
    assert_equal('C:/Workspace/rails-integration/jvyaml-0.2.1.jar',java_lib.searcheable_locations[6])
    assert_equal('C:/jruby/lib/jvyaml-0.2.1.jar',java_lib.searcheable_locations[7])
    assert_equal('C:/Workspace/rails-integration/jvyaml-0.2.2.jar',java_lib.searcheable_locations[8])
    assert_equal('C:/jruby/lib/jvyaml-0.2.2.jar',java_lib.searcheable_locations[9])
    assert_equal('C:/Workspace/rails-integration/jvyaml.jar',java_lib.searcheable_locations[10])
    assert_equal('C:/jruby/lib/jvyaml.jar',java_lib.searcheable_locations[11])
  end
  
  
end