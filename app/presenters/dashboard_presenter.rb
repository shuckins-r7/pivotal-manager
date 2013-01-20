class DashboardPresenter
  attr_reader :project, :members, :stories, :current_sprint

  PIVOTAL_STORY_STATES = ["accepted", "delivered", "finished", "started", "unstarted", "unscheduled"]
  PIVOTAL_STORY_TYPES  = ["bug", "feature", "chore", "release"]

  # Counts and arrays of all story states and types
  PIVOTAL_STORY_STATES.each do |state|
    define_method "#{state}_stories" do
      stories_by_state state
    end

    define_method "#{state}_stories_count" do
      stories_by_state(state).size
    end
  end

  PIVOTAL_STORY_TYPES.each do |type|
    define_method "#{type.pluralize}" do
      stories_by_type type
    end

    define_method "#{type.pluralize}_count" do
      stories_by_type(type).size
    end
  end

  def initialize
    ['project', 'members', 'stories'].each do |key|
      instance_variable_set("@#{key}", load_ruby_object_from_redis(key))
    end
  end

  def last_activity_at
    project.last_activity_at.strftime('%Y-%m-%d %I:%M%p')
  end

  def current_sprint_number
    project.current_iteration_number
  end

  def stories_by_state(state)
    stories.select{|s| s.current_state == state}
  end

  def stories_by_type(type)
    stories.select{|s| s.story_type == type}
  end

  # NOTE: returns current iteration and the next one
  def current_sprint
    Iteration.new(load_ruby_object_from_redis "current_iteration")
  end

  def current_stories(type=:all)
    if type == :all
      current_sprint.stories
    else
      current_sprint.stories.select{|s| s.story_type == type}
    end
  end

  def current_backlog
    load_ruby_object_from_redis "current_backlog"
  end

  def load_ruby_object_from_redis(key)
    Marshal.load RedisConnection.get(key)
  end

  # TEMP
  def self.load_from_pivotal
    project = PivotalTracker::Project.find(PivotalManager::PROJECT_ID)
    members = PivotalTracker::Membership.all(project)
    
    # Iteration stuff
    current_iteration = PivotalTracker::Iteration.current(project)
    current_backlog   = PivotalTracker::Iteration.current_backlog(project)

    # Just make this easy to hold while we dev on it -- will probably use Mongo later...?
    RedisConnection.set('project', Marshal.dump(project))
    RedisConnection.set('stories', Marshal.dump(project.stories.all))
    RedisConnection.set('members', Marshal.dump(members))
    RedisConnection.set('current_iteration', Marshal.dump(current_iteration))
    RedisConnection.set('current_backlog', Marshal.dump(current_backlog))
  end

end
