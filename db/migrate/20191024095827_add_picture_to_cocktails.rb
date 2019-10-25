class AddPictureToCocktails < ActiveRecord::Migration[6.0]
  def change
    add_column :cocktails, :picture, :string
  end
end
