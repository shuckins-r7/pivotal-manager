require "spec_helper"

describe MembersController do
  let(:member1){ FactoryGirl.create(:member)}
  let(:member2){ FactoryGirl.create(:member, name: "Sherman Horseface", initials: "SH", email: "sh@foo.com")}

  let(:all_members) {[member1, member2]}

  describe "GET#index" do
    it "should return all the Members in the DB" do
      Member.should_receive(:all)
      get :index
    end
  end

  describe "GET#show" do
    before(:each) do
      Member.stub(:find).and_return member1
    end

    it "should return a presenter initialized from a Member" do
      MemberPresenter.should_receive(:new).with(member1)
      get :show, :id => member1.id
    end
    
  end
end
