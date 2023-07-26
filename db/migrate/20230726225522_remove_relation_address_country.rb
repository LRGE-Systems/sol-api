class RemoveRelationAddressCountry < ActiveRecord::Migration[5.2]
  def change
    change_table :addresses do |t|
      t.remove :country_id
    end
  end
end
