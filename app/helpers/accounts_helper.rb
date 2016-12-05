module AccountsHelper
  def provider_image(provider_name)
    provider = provider_code(provider_name)

    image_tag("#{provider}.svg", height: "40", width: "40")
  end

  def provider_code(provider)
    case provider
    when "Kasikorn"
      "kbank"
    when "Bangkok Bank"
      "bbl"
    when "Krungsri"
      "bay"
    when "LH Bank"
      "lhb"
    when "SCB"
      "scb"
    when "KTB"
      "ktb"
    end
  end

  def provider_color(provider_name)
    @config ||= JSON.parse(File.read(Rails.root.join("config", "banks.json")))

    provider = provider_code(provider_name)

    return nil unless provider

    @config["th"][provider]["color"]
  end
end
