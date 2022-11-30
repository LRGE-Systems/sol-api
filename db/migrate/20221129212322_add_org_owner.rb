class AddOrgOwner < ActiveRecord::Migration[5.2]
  def change
    change_table :providers do |t|
      t.belongs_to :organization
    end
    change_table :cooperatives do |t|
      t.belongs_to :organization
    end
    change_table :items do |t|
      t.belongs_to :organization
    end
    change_table :covenants do |t|
      t.belongs_to :organization
    end
    change_table :biddings do |t|
      t.belongs_to :organization
    end
    change_table :reports do |t|
      t.belongs_to :organization
    end

    change_table :lot_proposals do |t|
      t.belongs_to :organization
    end

    change_table :proposals do |t|
      t.belongs_to :organization
    end

    change_table :lots do |t|
      t.belongs_to :organization
    end
  end
end
