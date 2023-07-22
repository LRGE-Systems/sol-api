class AddEmailToCooperativeLegalRepresentative < ActiveRecord::Migration[5.2]
  def change
    change_table :legal_representatives do |t|
      t.string :email
    end
    change_table :addresses do |t|
      t.string :country
    end
  end
end
