class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = MemberPresenter.new(Member.find(params[:id]))
  end
end
