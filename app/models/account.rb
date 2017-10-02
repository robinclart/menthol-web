class Account < ApplicationRecord
  def display_name
    [provider, name].join(" - ")
  end

  def amount
    Money.new(amount_subunit, currency)
  end
end
