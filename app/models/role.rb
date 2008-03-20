class Role < ActiveRecord::Base
  has_many :accesses
  has_many :users, :through => :accesses
end
