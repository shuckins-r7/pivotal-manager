class DashboardController < ApplicationController
  def index
    @d = DashboardPresenter.new
  end
end
