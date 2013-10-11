class Player < ActiveRecord::Base
  validates :player_no, inclusion: { in: [1,2, nil],
    message: "%{value} is not a valid player number" }
end
