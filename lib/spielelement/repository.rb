require 'json'
class SpielElementRepository
  attr_accessor :feld, :game_objects
  def initialize
    self.feld = Array.new(20) { Array.new(20, nil) }
    # TODO: Refactor class so that the repo stores player inside own var
    init_walls
  end

  def edit_mouse_click(x, y)
    build_block(mouse_cord(x).to_i, mouse_cord(y).to_i)
  end

  def edit_mouse_click_right(x, y)
    remove_block(mouse_cord(x).to_i, mouse_cord(y).to_i)
  end

  def import_map(path)
    init_walls
    walls = JSON.parse(File.read(path))
    walls.each do |wall|
      game_objects << SpielElement.new(wall['x'], wall['y'], repo: self)
    end
    # require 'pry'
    # binding.pry
  end

  def export_map(path)
    arr = []
    game_objects.each do |object|
      next if object.class != SpielElement
      arr << { x: object.x_pos, y: object.y_pos }
    end
    file = File.open("#{path}#{Time.now.to_i}_map.json", 'w+')
    file.write(JSON.pretty_generate(arr, object_nl: ''))
    puts "saved: #{file.inspect}"
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

  def mouse_cord(x)
    x / TILESIZE
  end

  def block_exists?(x, y)
    game_objects.each do |object|
      return true if x.eql?(object.x_pos) && y.eql?(object.y_pos)
    end
    false
  end

  def build_block(x, y)
    game_objects << SpielElement.new(x, y, repo: self) \
      unless block_exists?(x, y)
  end

  def remove_block(x, y)
    game_objects.each do |object|
      game_objects.delete(object) if x.eql?(object.x_pos) &&
                                     y.eql?(object.y_pos)
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
