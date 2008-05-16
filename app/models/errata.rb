class Errata < ActiveRecord::Base
  belongs_to :user
  
  acts_as_state_machine :initial => :pending
  state :pending
  state :reviewed
  
  event :publish do
    transitions :from => :pending, :to => :reviewed
  end
  
  def to_html
    doc = Maruku.new(self.description)
    doc.to_html
  end
    
end
