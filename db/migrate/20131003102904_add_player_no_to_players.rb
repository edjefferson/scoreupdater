class AddPlayerNoToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :player_no, :integer
  end
end
