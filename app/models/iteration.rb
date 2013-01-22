class Iteration
  include Mongoid::Document

  # Set up the fields and relations for the document, mirroring the 
  # structure of PivotalTracker::Iteration, which is based on HappyMapper
  #
  # https://github.com/jnunemaker/happymapper
  PivotalTracker::Iteration.elements.each do |e|
    if e.name == "id"  # Don't override MongoDB's id
      field :pt_id, type: Integer
    elsif e.name == "stories"
      has_many :stories, :autosave => true
    else
      field e.name.to_sym, type: e.type
    end
  end

  def self.bootstrap!
    project = PivotalTracker::Project.find(PivotalManager::PROJECT_ID)
    
    done_iterations   = project.iteration(:done)
    current_iteration = project.iteration(:current)

    # Make Iteration and Story objects for finished stuff
    done_iterations.each do |done|
      self.new_from_pt_iteration(done).save!
    end
    
    # Make current Iteration and associated Stories for current stuff
    self.iteration_from_pt(current_iteration)

    # Make the memberships
    project.memberships.all.each{|m| Member.member_from_pt(m) }
  end

  # Map PivotalTracker::Iteration objects to Iteration objects, creating
  # component Story objects in the process
  def self.iteration_from_pt(pt_iteration)
    iteration = self.where(pt_id: pt_iteration.id).first || self.new
    PivotalTracker::Iteration.elements.each do |e|
      attr_name = e.name
      
      case attr_name
    
      # Guard Mongo's native ID
      when "id"
        iteration.pt_id = pt_iteration.id

      # Create component stories
      when "stories"
        pt_iteration.stories.each do |pt_story|
          iteration.stories << Story.new_from_pt_story(pt_story)
        end

      # Set Iteration attributes from PivotalTracker gem
      else
        iteration.send("#{attr_name}=", pt_iteration.send(attr_name))
      end
    end
    iteration
  end

end
