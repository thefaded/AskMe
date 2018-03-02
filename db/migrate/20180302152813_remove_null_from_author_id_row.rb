class RemoveNullFromAuthorIdRow < ActiveRecord::Migration[5.1]
  def change
    change_column :questions, :author_id, :integer, :null => true
  end
end
