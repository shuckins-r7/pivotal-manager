class MemberPresenter
  attr_reader :member

  def initialize(member)
    @member = member
  end

  def name
    "#{@member.name} - #{@member.initials}"
  end

end

