# coding: utf-8

TILESIZE=30
BORDER=40

module Berufsorientierungstag
  class SpielElement
    attr_reader :x_pos, :y_pos
    def initialize(x=1, y=1)
      self.x_pos=x
      self.y_pos=y
      init_sprite
    end

    def update
    end

    def draw
      sprite.draw_rot(calc_cord(x_pos), calc_cord(y_pos), 1, 0)
    end

    private
    attr_accessor :sprite
    attr_writer :x_pos, :y_pos

    def init_sprite
      self.sprite = Gosu.record(TILESIZE, TILESIZE) do
        Gosu.draw_rect(5, 5, TILESIZE-5, TILESIZE-5, random_color)
      end
    end

    def calc_cord(cord)
      return (cord*TILESIZE)+BORDER
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
      self.feld.each do |zeile|
        zeile.each(&:draw)
        print "\n"
      end
    end

    private
    def init_feld
      (0...20).each do |num_1|
        (0...20).each do |num_2|
          self.feld[num_1][num_2] = SpielElement.new(num_1, num_2)
        end
      end
    end
  end
end
