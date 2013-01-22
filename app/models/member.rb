#
# Represents a dev team member.  I like this better than "Membership" 
# for how I'm thinking of using this data.
#

class Member
  include Mongoid::Document

  # Set up the fields and relations for the document, mirroring the 
  # structure of PivotalTracker::Story, which is based on HappyMapper
  #
  # https://github.com/jnunemaker/happymapper
  PivotalTracker::Membership.elements.each do |e|
    if e.name == "id" # Don't override MongoDB's id
      field :pt_id, type: Integer
    else
      field e.name.to_sym, type: e.type
    end
  end

  # Translate PivotalTracker::Membership to a Member object
  def self.member_from_pt(pt_membership)
    member = self.where(pt_id: pt_membership.id).first || self.new
    PivotalTracker::Membership.elements.each do |e|
      attr_name = e.name
      if attr_name == "id"
        member.pt_id = pt_membership.id
      else
        member.send("#{attr_name}=", pt_membership.send(attr_name))
      end
    end
    member.save!
  end

end
