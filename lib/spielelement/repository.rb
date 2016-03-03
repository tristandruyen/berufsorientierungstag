require 'json'
class SpielElementRepository
  attr_accessor :feld, :game_objects
  def initialize
    self.feld = Array.new(20) { Array.new(20, nil) }
    init_walls
  end

  def import_map(path)
    init_walls
    walls = JSON.parse(File.read(path))['walls']
    walls.each do |wall|
      game_objects << SpielElement.new(wall['x'], wall['y'], repo: self)
    end
    # require 'pry'
    # binding.pry
  end

  def export_map(path)
    arr = []
    game_objects.each do |object|
      next if object.class!=SpielElement
      arr << {x: object.x_pos, y: object.y_pos}
    end
    file=File.open("#{path}#{Time.now}_map.json", 'w+')
    file.write(JSON.pretty_generate(arr, object_nl: ''))
    file.close
  end

  def draw_all
    game_objects.each(&:draw)
  end

  def build_wall(x1, x2, y1, y2)
    iterate_field(x1, x2, y1, y2) do |n_1, n_2|
      build_block(n_1, n_2)
    end
  end
  private

  def init_walls
    self.game_objects = []
    # iterate_field(0, 0, 0, 19) do |n_1, n_2|
    #   game_objects << SpielElement.new(n_1, n_2, repo: self)
    # end
    build_wall(0, 0, 0, 19)
    build_wall(19, 19, 0, 19)
    build_wall(0, 19, 0, 0)
    build_wall(0, 19, 19, 19)
  end

  def load_map
  end


  def build_block(x, y)
    game_objects << SpielElement.new(x, y, repo: self)
  end

  def iterate_field(x1, x2, y1, y2)
    (x1..x2).each do |num_1|
      (y1..y2).each do |num_2|
        yield num_1, num_2
      end
    end
  end
end
