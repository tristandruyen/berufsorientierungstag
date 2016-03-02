class SpielElementRepository
  attr_accessor :feld, :game_objects
  def initialize
    self.feld = Array.new(20) { Array.new(20, nil) }
    self.game_objects = []
    init_walls
  end

  def draw_all
    game_objects.each(&:draw)
  end

  private

  def init_walls # rubocop:disable Metrics/AbcSize
    iterate_field(0, 0, 0, 19) do |n_1, n_2|
      game_objects << SpielElement.new(n_1, n_2, repo: self)
    end

    iterate_field(19, 19, 0, 19) do |n_1, n_2|
      game_objects << SpielElement.new(n_1, n_2, repo: self)
    end

    iterate_field(0, 19, 0, 0) do |n_1, n_2|
      game_objects << SpielElement.new(n_1, n_2, repo: self)
    end

    iterate_field(0, 19, 19, 19) do |n_1, n_2|
      game_objects << SpielElement.new(n_1, n_2, repo: self)
    end
  end

  def iterate_field(x1, x2, y1, y2)
    (x1..x2).each do |num_1|
      (y1..y2).each do |num_2|
        yield num_1, num_2
      end
    end
  end
end
