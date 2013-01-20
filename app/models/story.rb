#
#
# Represent a PivotalTracker story as a MongoDB document,
# ported/translated from the PivotalTracker::Story element schema.
#
#
#


class Story
  include Mongoid::Document
  
  # Create a Mongoid document structure from the PivotalTracker::Story class's HappyMapper structure
  # which maps XML from the PivotalTracker public API to Ruby objects
  #
  # https://github.com/jnunemaker/happymapper
  PivotalTracker::Story.elements.each do |e|
    if e.name == "id" # Don't override MongoDB's id
      field :pt_id, type: Integer
    else
      field e.name.to_sym, type: e.type
    end
  end

  
  # Populate an empty database w/ all existing PT stories
  def self.bootstrap!
    self.all_from_pivotal.each{|s| self.create_from_pt_story(s)}
  end

  # Fetch all data from PT
  def self.all_from_pivotal
    PivotalTracker::Project.find(PivotalManager::PROJECT_ID).stories.all
  end

  # Use refelection to translate a PivotalTracker::Story into a Story (this class)
  def self.create_from_pt_story(pt_story)
    story = self.new
    PivotalTracker::Story.elements.each do |e|
      attr_name = e.name
      next if attr_name == "attachments"       # We don't need to pull attachments here
      if attr_name == "id"                     # Don't override MongoDB's id
        story.pt_id = pt_story.id
      else
        story.send("#{attr_name}=", pt_story.send(attr_name))
      end
    end
    story.save
  end

end
