class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.integer :first_throw
      t.integer :second_throw
      t.integer :third_throw

      t.timestamps
    end
  end
end
