class BoardPinner < ActiveRecord::Base
  belongs_to :user, inverse_of: :board_pinners
  belongs_to :board, inverse_of: :board_pinners
end
