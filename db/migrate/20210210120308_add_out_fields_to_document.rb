class AddOutFieldsToDocument < ActiveRecord::Migration[5.2]
  def change
    change_table(:documents) do |t|
      t.date :document_date, :null => true
      t.string :document_number, :null => true
      t.integer :document_type, :null=>true
    end
  end
end
