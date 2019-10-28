class KrungsriTx
  def initialize(created_at:, description: "", kind:, amount_subunit:, balance_subunit:, channel: "", memo: "")
    @created_at      = created_at
    @description     = description
    @kind            = kind
    @amount_subunit  = amount_subunit
    @balance_subunit = balance_subunit
    @channel         = channel
    @memo            = memo
  end

  def self.parse(data)
    Time.use_zone("Asia/Bangkok") do
      created_at = Time.zone.parse(data[0]).end_of_day
      channel = data[1]

      if data[4].present?
        kind = "debit"
        opposite_kind = "credit"
        description = "Withdrawal"
        amount_subunit = (data[4].gsub(",", "").to_f * 100).round(0)
      else
        kind = "credit"
        opposite_kind = "debit"
        description = "Deposit"
        amount_subunit = (data[5].gsub(",", "").to_f * 100).round(0)
      end

      balance_subunit = (data[6].gsub(",", "").to_f * 100).round(0)

      paired_transaction = Transaction.where({
        amount_subunit: amount_subunit,
        kind: opposite_kind,
        created_at: created_at.beginning_of_day..created_at.end_of_day,
      }).first

      if paired_transaction
        if kind == "credit"
          created_at = paired_transaction.created_at + 1.second
        else
          created_at = paired_transaction.created_at - 1.second
        end
      end

      new({
        created_at:      created_at,
        description:     description,
        kind:            kind,
        amount_subunit:  amount_subunit,
        balance_subunit: balance_subunit,
        channel:         channel,
      })
    end
  end

  attr_reader :created_at, :description, :kind, :amount_subunit, :balance_subunit, :channel, :memo

  def digest
    str = [created_at.iso8601, kind, amount_subunit.to_s].join
    Digest::SHA1.hexdigest(str)
  end
end
