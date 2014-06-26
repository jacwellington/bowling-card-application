class AddNumberToFrame < ActiveRecord::Migration
  def change
    add_column :frames, :number, :integer
  end
end
