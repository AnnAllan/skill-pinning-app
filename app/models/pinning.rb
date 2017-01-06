class Pinning < ActiveRecord::Base
	belongs_to :user, inverse_of: :pinnings
	belongs_to :pin, inverse_of: :pinnings
	belongs_to :board, inverse_of: :pinnings
end