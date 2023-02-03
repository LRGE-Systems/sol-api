class AddCountryToOrg < ActiveRecord::Migration[5.2]
  def change
    change_table :organizations do |t|
      t.string :country
      t.string :projectId
    end
    add_index :organizations, :projectId, unique: true
  end
end
