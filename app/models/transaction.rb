class Transaction < ApplicationRecord
  belongs_to :account

  def self.create_from_provider_tx(tx)
    create({
      description:     tx.description,
      kind:            tx.kind,
      amount_subunit:  tx.amount_subunit,
      balance_subunit: tx.balance_subunit,
      channel:         tx.channel,
      memo:            tx.memo,
      digest:          tx.digest,
      created_at:      tx.created_at,
    })
  end

  def self.transfers
    where.not(paired_transaction_id: nil).order("created_at DESC")
  end

  def self.credits
    where(paired_transaction_id: nil, kind: "credit").order("created_at DESC")
  end

  def self.debits
    where(paired_transaction_id: nil, kind: "debit").order("created_at DESC")
  end

  def self.by_type(type)
    case type
    when "transfers"
      transfers
    when "debits"
      debits
    when "credits"
      credits
    else
      order("created_at DESC").all
    end
  end

  def paired_transaction
    Transaction.find(paired_transaction_id) if paired_transaction_id
  end

  def paired_transaction?
    paired_transaction_id?
  end

  def link_paired_transaction
    tx = Transaction.where.not(account: account).where({
      amount_subunit: amount_subunit,
      kind: opposite_kind,
      created_at: created_at.beginning_of_day..created_at.end_of_day,
    }).first

    if tx
      update paired_transaction_id: tx.id
      tx.update paired_transaction_id: self.id
    end
  end

  def opposite_kind
    if kind == "credit"
      "debit"
    else
      "credit"
    end
  end

  def amount
    Money.new(amount_subunit, account.currency)
  end
end
