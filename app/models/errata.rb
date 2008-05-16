class Errata < ActiveRecord::Base
  belongs_to :user
  
  acts_as_state_machine :initial => :pending
  state :pending
  state :fixed
  
  event :publish do
    transitions :from => :pending, :to => :fixed
  end
    
end
