steps_for :pages do

  Given "no pages in the system" do
    Page.destroy_all
  end
  
  Given "$number pages in the system" do |nr_of_pages|
    nr_of_pages.to_i.times do |i|
      Page.create :title => "Titel #{i}", :body => "Inhalt #{i}"
    end
  end
  
end