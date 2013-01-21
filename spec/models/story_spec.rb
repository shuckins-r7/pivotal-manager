require "spec_helper"

describe Story do
  let(:started_stories) do
    [FactoryGirl.create(:story), FactoryGirl.create(:story)]
  end

  let(:finished_stories) do
    [FactoryGirl.create(:story, :current_state => "finished"),
     FactoryGirl.create(:story, :current_state => "finished")]
  end

  describe "active" do
    before(:each) do
      started_stories
      finished_stories
    end

    describe "#started" do
      it "should find all the stories in the DB that are Started" do
        Story.started.to_a.should =~ started_stories
      end
    end

    describe "#finished" do
      it "should find all the stories in the DB that are Finished" do
        Story.finished.to_a.should =~ finished_stories
      end
    end
  end

  describe "#owned_by_member" do
    it "should return all the stories owned by the member with the given name" do
      
    end
  end

  describe "#requested_by_member" do
    it "should return all the stories requrested by the member with the given name" do
      
    end
  end
  
end
