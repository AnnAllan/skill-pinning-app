class Board < ActiveRecord::Base
	validates_presence_of :name
  belongs_to :user
  has_many :pinnings, inverse_of: :board, dependent: :destroy
  has_many :pins, through: :pinnings
  has_many :board_pinners, inverse_of: :board, dependent: :destroy
  accepts_nested_attributes_for :board_pinners
end
