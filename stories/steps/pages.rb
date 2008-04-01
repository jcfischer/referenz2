steps_for :pages do

  Given /no (\w+) in the system/ do |klass|
    klass.singularize.camelize.constantize.destroy_all
  end
  
  Given "$number pages in the system" do |nr_of_pages|
    nr_of_pages.to_i.times do |i|
      Page.create :title => "Titel #{i}", :body => "Inhalt #{i}"
    end
  end
  
  # 
  #   there should be 1 Comment in...
  #   there should be 42 Pages in...
  Then /there should be (\d+) (\w+) in the system/ do |nr_of_objects, klass|
    klass.singularize.camelize.constantize.count.should == nr_of_objects.to_i
  end
  
  When /opening first (\w+)/ do |klass|
    @obj = klass.singularize.camelize.constantize.find :first
    visits "/#{klass}s/#{@obj.to_param}"
  end
end