class User < ActiveRecord::Base
  has_many :pages
  has_one :preference
  has_many :accesses
  has_many :roles, :through => :accesses
end
