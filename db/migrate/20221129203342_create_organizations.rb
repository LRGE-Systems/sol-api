class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.timestamps
    end
    change_table :admins do |t|
      t.belongs_to :organization
    end
    change_table :suppliers do |t|
      t.belongs_to :organization
    end
    change_table :users do |t|
      t.belongs_to :organization
    end

  end
end
