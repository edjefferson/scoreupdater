class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :player_one
      t.string :player_two
      t.integer :score_one
      t.integer :score_two

      t.timestamps
    end
  end
end
