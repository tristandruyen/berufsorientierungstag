class SpielElement
  attr_reader :x_pos, :y_pos, :repository
  def initialize(x = 1, y = 1, repo:)
    self.repository = repo
    self.x_pos = x
    self.y_pos = y
    init_sprite
  end

  def draw
    sprite.draw_rot(calc_cord(x_pos), calc_cord(y_pos), 1, @angle || 0)
  end

  private

  attr_accessor :sprite
  attr_writer :x_pos, :y_pos, :repository

  def init_sprite
    self.sprite = Gosu.record(TILESIZE, TILESIZE) do
      Gosu.draw_rect(TILESIZE / 10, TILESIZE / 10,
                     TILESIZE * 9 / 10, TILESIZE * 9 / 10,
                     random_color)
    end
  end

  def calc_cord(cord)
    (cord * TILESIZE) + BORDER
  end

  def random_color
    color = Gosu::Color.new(0xff_000000)
    color.red = rand(256 - 40) + 40
    color.green = rand(256 - 40) + 40
    color.blue = rand(256 - 40) + 40
    color
  end
end
