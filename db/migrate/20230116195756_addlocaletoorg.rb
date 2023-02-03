class Addlocaletoorg < ActiveRecord::Migration[5.2]
  def change
    change_table :organizations do |t|
      t.integer :locale
    end
  end
end
