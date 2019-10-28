require "csv"

class AccountsController < ApplicationController
  before_action :load_all_accounts
  before_action :find_account, only: [:show, :update]

  def index
    @transactions = Transaction.by_type(params[:type].to_s)
  end

  def show
    @transactions = @account.transactions_by_type(params[:type].to_s)
  end

  def update
    transactions = CSV.parse(params[:transactions].read)
    @account.add_transactions(transactions)
    redirect_to account_path(@account)
  end

  private

  def find_account
    @account = Account.find(params[:id])
  end

  def load_all_accounts
    @accounts = Account.all.sort { |x,y| x.display_name <=> y.display_name }
  end
end
