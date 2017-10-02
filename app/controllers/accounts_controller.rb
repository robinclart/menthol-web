class AccountsController < ApplicationController
  def index
    @accounts = Account.all.sort { |x,y| x.display_name <=> y.display_name }
  end
end
