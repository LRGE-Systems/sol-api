class AddSenarCustomDocsToContract < ActiveRecord::Migration[5.2]
  def change
    change_table(:contracts) do |t|
      t.references :service_order_document, index: true, foreign_key: { to_table: :documents }
      t.references :buy_approval_document, index: true, foreign_key: { to_table: :documents }
    end
  end
end
