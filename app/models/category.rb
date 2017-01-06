class Category < ActiveRecord::Base
	validates_presence_of :name, uniqness: true
	has_many :pins, dependent: :destroy
end
