require 'json'
class Spielfeld
  attr_accessor :game_objects, :players
  def initialize(zielx = 18, ziely = 18)
    self.players = []
    init_walls
    add_player(1, 1)
    @zielx = zielx
    @ziely = ziely
  end

  def editable?
    @edit_mode
  end

  def toggle_edit
    @edit_mode = !@edit_mode
  end

  def target_mouse_click(x, y)
    return false unless @edit_mode
    @zielx = mouse_cord(x)
    @ziely = mouse_cord(y)
  end

  def edit_mouse_click(x, y)
    build_block(mouse_cord(x).to_i, mouse_cord(y).to_i)
  end

  def edit_mouse_click_right(x, y)
    remove_block(mouse_cord(x).to_i, mouse_cord(y).to_i)
  end

  def import_map(path)
    game_objects.each do |object|
      game_objects.delete(object)
    end
    import = JSON.parse(File.read(path))
    walls = import['walls']
    walls.each do |wall|
      build_block(wall['x'], wall['y'])
    end
    return nil unless import['target']
    @zielx=import['target']['x']
    @ziely=import['target']['y']
  end

  def export_map(path)
    arr = []
    game_objects.each do |object|
      next if object.class != SpielElement
      arr << { x: object.x_pos, y: object.y_pos }
    end
    export = { walls: arr, target: {x: @zielx, y:@ziely}}
    write_to_file(path, export)
  end

  def draw_all
    game_objects.each(&:draw)
    players.each(&:draw)
  end

  def call_all
    checkwin
    players.each(&:call) unless @edit_mode
  end

  def build_wall(x1, x2, y1, y2)
    iterate_field(x1, x2, y1, y2) do |n_1, n_2|
      build_block(n_1, n_2)
    end
  end

  def add_player(x = 1, y = 1)
    players << Spieler.new(x, y, repo: self)
    players.last.init
  end

  private

  def checkwin
    players.each do |player|
      if player.x_pos == @zielx && player.y_pos == @ziely
        import_map('maps/you_won.json')
        toggle_edit
        return true
      end
    end
    false
  end

  def init_walls
    self.game_objects = []
    # iterate_field(0, 0, 0, 19) do |n_1, n_2|
    #   game_objects << SpielElement.new(n_1, n_2, repo: self)
    # end
    build_wall(0, 0, 0, ROWS_ON_SCREEN - 1)
    build_wall(ROWS_ON_SCREEN - 1, ROWS_ON_SCREEN - 1, 0, ROWS_ON_SCREEN - 1)
    build_wall(0, ROWS_ON_SCREEN - 1, 0, 0)
    build_wall(0, ROWS_ON_SCREEN - 1, ROWS_ON_SCREEN - 1, ROWS_ON_SCREEN - 1)
  end

  def write_to_file(path, arr)
    file = File.open("#{path}#{Time.now.to_i}_map.json", 'w+')
    file.write(JSON.pretty_generate(arr, object_nl: ''))
    puts "saved: #{file.inspect}"
    file.close
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
    game_objects << SpielElement.new(x, y, repo: self) unless block_exists? x, y
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
