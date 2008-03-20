class Category < ActiveRecord::Base
  has_many :pages, :include => :user
end
