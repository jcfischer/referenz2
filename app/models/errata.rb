class Errata < ActiveRecord::Base
  belongs_to :user
  
  acts_as_state_machine :initial => :new
  state :new
  state :fixed
    
end
