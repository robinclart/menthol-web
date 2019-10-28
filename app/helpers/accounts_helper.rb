module AccountsHelper
  def render_account_as_book(account)
    render "accounts/book", book_hash(account)
  end

  def book_hash(account)
    {
      id:           account.id,
      provider:     account.provider,
      name:         account.display_name,
      amount:       account.amount,
      last_update:  account.updated_at&.in_time_zone("Asia/Bangkok"),
    }
  end

  def provider_image(provider_name)
    provider = provider_code(provider_name)

    image_tag("#{provider}.svg", height: "40", width: "40")
  end

  def provider_code(provider)
    case provider
    when "Kasikornbank"
      "kbank"
    when "Bangkokbank"
      "bbl"
    when "Krungsri"
      "bay"
    when "LH Bank"
      "lhb"
    when "SCB"
      "scb"
    when "KTB"
      "ktb"
    when "UOB"
      "uob"
    when "UOBAM"
      "uob"
    end
  end

  def provider_color(provider_name)
    @config ||= JSON.parse(File.read(Rails.root.join("config", "banks.json")))

    provider = provider_code(provider_name)

    return nil unless provider

    @config["th"][provider]["color"]
  end
end
