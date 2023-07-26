class ChangeAddressCountry < ActiveRecord::Migration[5.2]
  def change
    change_table :addresses do |t|
      t.remove :country
      t.belongs_to :country
    end
  end
end
