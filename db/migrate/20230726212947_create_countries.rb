class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.string :sigla

      t.timestamps
    end

    change_table :states do |t|
      t.belongs_to :country
    end
  end
end
