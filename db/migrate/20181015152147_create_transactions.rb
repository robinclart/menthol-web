class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.text :description
      t.integer :amount_subunit
      t.string :kind
      t.integer :balance_subunit
      t.string :channel
      t.text :memo
      t.string :digest
      t.references :account, foreign_key: true
      t.references :paired_transaction

      t.timestamps
    end
  end
end
