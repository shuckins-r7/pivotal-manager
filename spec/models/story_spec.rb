require "spec_helper"

describe Story do
  let(:member){ FactoryGirl.create(:member)}

  let(:started_stories) do
    [FactoryGirl.create(:story), FactoryGirl.create(:story)]
  end

  let(:finished_stories) do
    [FactoryGirl.create(:story, :current_state => "finished"),
     FactoryGirl.create(:story, :current_state => "finished")]
  end

  let(:delivered_stories) do
    [FactoryGirl.create(:story, :current_state => "delivered"),
     FactoryGirl.create(:story, :current_state => "delivered")]
  end

  describe "active" do
    before(:each) do
      started_stories
      finished_stories
      delivered_stories
    end

    it "should have all started, finished, delivered stories via #active" do
      Story.active.to_a.should =~ Story.started.to_a + Story.finished.to_a + Story.delivered.to_a
    end

    describe "#started" do
      it "should find all the stories in the DB that are Started" do
        Story.started.to_a.should =~ started_stories
      end
    end

    describe "#delivered" do
      it "should find all the stories in the DB that are Delivered" do
        Story.delivered.to_a.should =~ delivered_stories
      end
    end

    describe "#finished" do
      it "should find all the stories in the DB that are Finished" do
        Story.finished.to_a.should =~ finished_stories
      end
    end
  end

  describe "#owned_by_member" do
    let!(:owned_story){FactoryGirl.create(:story, :owned_by => member.name)}

    it "should return all the stories owned by the member with the given name" do
      Story.owned_by_member(member).to_a.should =~ [owned_story]
      
    end
  end

  describe "#requested_by_member" do
    let!(:requested_story){FactoryGirl.create(:story, :requested_by => member.name)}

    it "should return all the stories requrested by the member with the given name" do
      Story.requested_by_member(member).to_a.should =~ [requested_story]
    end
  end
  
end
