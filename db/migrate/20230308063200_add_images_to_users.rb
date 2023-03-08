class AddImagesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :images, :string
  end
end
