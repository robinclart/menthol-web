class KasikornbankTx
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
      created_at = Time.zone.parse(data[0])
      description = data[1]

      if data[2].present?
        kind = "debit"
        amount_subunit = (data[2].gsub(",", "").to_f * 100).round(0)
      else
        kind = "credit"
        amount_subunit = (data[3].gsub(",", "").to_f * 100).round(0)
      end

      balance_subunit = (data[4].gsub(",", "").to_f * 100).round(0)
      channel = data[5]
      memo = data[6]

      new({
        created_at:      created_at,
        description:     description,
        kind:            kind,
        amount_subunit:  amount_subunit,
        balance_subunit: balance_subunit,
        channel:         channel,
        memo:            memo,
      })
    end
  end

  attr_reader :created_at, :description, :kind, :amount_subunit, :balance_subunit, :channel, :memo

  def digest
    str = [created_at.iso8601, kind, amount_subunit.to_s].join
    Digest::SHA1.hexdigest(str)
  end
end
