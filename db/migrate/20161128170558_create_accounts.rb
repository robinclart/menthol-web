class CreateAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :accounts do |t|
      t.string :provider
      t.string :name
      t.integer :amount_subunit
      t.string :currency

      t.timestamps
    end
  end
end
