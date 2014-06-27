class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :bowling_game, index: true
      t.text :body

      t.timestamps
    end
  end
end
