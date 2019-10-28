class Account < ApplicationRecord
  has_many :transactions

  def display_name
    [provider, name].join(" - ")
  end

  def amount
    Money.new(amount_subunit, currency)
  end

  def all_transactions
    transactions.order(created_at: :desc)
  end

  def transactions_by_type(type)
    transactions.by_type(type)
  end

  def add_transactions(rows)
    rows.each do |row|
      tx = Object.const_get("#{provider}Tx").parse(row)

      if transactions.find_by(digest: tx.digest)
        next
      end

      transactions.create_from_provider_tx(tx)
    end

    Transaction.all.each(&:link_paired_transaction)
  end
end
