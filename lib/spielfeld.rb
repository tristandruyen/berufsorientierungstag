# coding: utf-8

TILESIZE = 40
BORDER = 17.5

module Berufsorientierungstag
  class DummyElement
    def initialize
    end

    def draw
    end
  end

  class SpielElement
    attr_reader :x_pos, :y_pos
    def initialize(x = 1, y = 1)
      self.x_pos = x
      self.y_pos = y
      init_sprite
    end

    def draw
      sprite.draw_rot(calc_cord(x_pos), calc_cord(y_pos), 1, 0)
    end

    private

    attr_accessor :sprite
    attr_writer :x_pos, :y_pos

    def init_sprite
      self.sprite = Gosu.record(TILESIZE, TILESIZE) do
        Gosu.draw_rect(5, 5, TILESIZE - 5, TILESIZE - 5, random_color)
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

  class Spieler < SpielElement
    def initialize(x = 1, y = 1)
      self.x_pos = x
      self.y_pos = y
      @angle = 0
      init_sprite
    end

    def vor!
      case @angle
      when 0 then @x_pos[0] += 1
      when 90 then @y_pos[0] += 1
      when 180 then @x_pos[0] -= 1
      when 270 then @y_pos[0] -= 1
      end unless vorne_frei?
    end

    def vorne_frei?
    end

    def dreh_links!
      @angle -= 90
    end

    def dreh_rechts!
      @angle += 90
    end
  end

  class Spielfeld
    attr_accessor :feld
    def initialize
      self.feld = Array.new(20) { Array.new(20, nil) }
      init_feld
    end

    def update
    end

    def draw
      system('clear')
      feld.each do |zeile|
        zeile.each(&:draw)
      end
    end

    private

    def init_feld
      iterate_field(0, 19, 0, 19) do |n_1, n_2|
        feld[n_1][n_2] = DummyElement.new
      end

      iterate_field(0, 0, 0, 19) do |n_1, n_2|
        feld[n_1][n_2] = SpielElement.new(n_1, n_2)
      end

      iterate_field(19, 19, 0, 19) do |n_1, n_2|
        feld[n_1][n_2] = SpielElement.new(n_1, n_2)
      end

      iterate_field(0, 19, 0, 0) do |n_1, n_2|
        feld[n_1][n_2] = SpielElement.new(n_1, n_2)
      end

      iterate_field(0, 19, 19, 19) do |n_1, n_2|
        feld[n_1][n_2] = SpielElement.new(n_1, n_2)
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
end
