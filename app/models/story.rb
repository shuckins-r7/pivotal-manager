#
#
# Represent a PivotalTracker story as a MongoDB document,
# ported/translated from the PivotalTracker::Story element schema.
#
#
#


class Story
  include Mongoid::Document
  
  # Set up the fields and relations for the document, mirroring the 
  # structure of PivotalTracker::Story, which is based on HappyMapper
  #
  # https://github.com/jnunemaker/happymapper
  PivotalTracker::Story.elements.each do |e|
    if e.name == "id" # Don't override MongoDB's id
      field :pt_id, type: Integer
    else
      field e.name.to_sym, type: e.type
    end
  end

  belongs_to :iteration
  scope :started, where(current_state: "started")
  scope :finished, where(current_state: "finished")


  # Use refelection to translate a PivotalTracker::Story into a Story (this class)
  def self.new_from_pt_story(pt_story)
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
    story
  end

end
