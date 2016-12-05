class API::AccountsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    payload = JSON.parse(request.body.read).deep_symbolize_keys

    payload[:accounts].each do |a|
      account = Account.find_or_create_by({
        provider: a[:provider],
        name:     a[:name],
      })

      account.update({
        amount_subunit: a[:amount],
        currency:       a[:currency]
      })
    end

    render json: generate_json(status: "ok")
  end

  private

  def generate_json(object)
    JSON.pretty_generate(object) << "\n"
  end
end
