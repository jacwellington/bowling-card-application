class CreateBowlingGames < ActiveRecord::Migration
  def change
    create_table :bowling_games do |t|
      t.references :user, index: true
      t.integer :score

      t.timestamps
    end
  end
end
