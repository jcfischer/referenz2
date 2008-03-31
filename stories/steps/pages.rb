steps_for :pages do

  Given "no pages in the system" do
    Page.destroy_all
  end
  
  Given "$number pages in the system" do |nr_of_pages|
    nr_of_pages.to_i.times do |i|
      Page.create :title => "Titel #{i}", :body => "Inhalt #{i}"
    end
  end
  
  # Wir nutzen $page_pages als Platzhalter, damit folgendes möglich ist:
  #   there should be 1 page in...
  #   there should be 42 pages in...
  Then "there should be $number $page_pages in the system" do |nr_of_pages, dummy|
    Page.count.should == nr_of_pages.to_i
  end
  
  When "opening first page" do
    @page = Page.find :first
    visits "/pages/#{@page.to_param}"
  end
end