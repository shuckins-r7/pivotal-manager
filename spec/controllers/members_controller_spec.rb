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

    describe "GET#index format: JSON" do
      before(:each) do
        Member.stub(:all).and_return all_members
      end

      it "should return all members as JSON when requested" do
        pending "deciding how to handle JSON in tables here"
        all_members.should_receive(:to_json)
        get :index, format: :json
      end
    end
  end

  describe "GET#show" do
    before(:each) do
      Member.stub(:where).and_return member1
    end

    it "should return the Member represented by the PT id" do
      pending
    end
    
  end
end
