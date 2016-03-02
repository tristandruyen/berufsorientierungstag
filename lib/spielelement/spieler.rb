TILESIZE = 40
class Spieler < SpielElement
  def initialize(*args)
    super(*args)
    @angle = 0
  end

  def vor!
    self.x_pos, self.y_pos = next_pos if vorne_frei?
  end

  def vorne_frei?
    repository.game_objects.each do |obj|
      return false if next_pos == [obj.x_pos, obj.y_pos]
    end
    true
  end

  def dreh_links!
    @angle -= 90
    @angle %= 360
  end

  def dreh_rechts!
    @angle += 90
    @angle %= 360
  end

  private

  attr_reader :angle

  def init_sprite
    @sprite = Gosu.record(TILESIZE, TILESIZE) do
      draw_triangle(TILESIZE / 10, TILESIZE / 10, random_color, TILESIZE * 9 / 10, TILESIZE / 2, random_color, TILESIZE / 10, TILESIZE + 9 / 10, random_color)
    end
  end

  def draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3)
    Gosu.draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x3, y3, c3)
  end

  def next_pos
    x_mov, y_mov = 0, 0 # rubocop:disable Style/ParallelAssignment
    case angle
    when 0 then x_mov = 1
    when 90 then y_mov = 1
    when 180 then x_mov = -1
    when 270 then y_mov = -1
    end
    [x_pos + x_mov, y_pos + y_mov]
  end
end
