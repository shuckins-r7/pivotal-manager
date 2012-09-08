class Iteration
  attr_reader :start_time, :end_time, :stories

  def initialize(iteration)
    @start_time, @end_time = iteration.start, iteration.finish
    @stories = iteration.stories
  end

  def start_time
    @start_time.strftime('%Y-%m-%d')
  end

  def end_time
    @end_time.strftime('%Y-%m-%d')
  end

end
