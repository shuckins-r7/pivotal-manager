class DashboardController < ApplicationController
  def index
    @d = Dashboard.new
  end
end
