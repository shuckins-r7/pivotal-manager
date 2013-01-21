class MemberPresenter
  attr_reader :member

  def initialize(member)
    @member = member
  end

  def name
    "#{@member.name} (#{@member.initials})"
  end

  def has_current_commitments?
    current_owned_stories.present?
  end

  # "Reqested by" this member in the current iteration
  # TODO: implement a robust concept of current iteration, based on current date
  # replace the Iteration.last call here w/ that.
  def current_requested_stories
    Iteration.last.stories.active.requested_by_member(member)
  end

  def current_owned_stories
    Iteration.last.stories.active.owned_by_member(member)
  end

end

