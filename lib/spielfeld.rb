# coding: utf-8

TILESIZE = 40
BORDER = 17.5

module Berufsorientierungstag
  class SpielElement
    attr_reader :x_pos, :y_pos, :repository
    def initialize(x = 1, y = 1, repo:)
      self.repository = repo
      self.x_pos = x
      self.y_pos = y
      init_sprite
    end

    def draw
      sprite.draw_rot(calc_cord(x_pos), calc_cord(y_pos), 1, 0)
    end

    private

    attr_accessor :sprite
    attr_writer :x_pos, :y_pos, :repository

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
    def initialize(x = 0, y = 0, repo:)
      super(x, y, repo: repo)
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

  class GameObjectRepository
    attr_accessor :feld, :game_objects
    def initialize
      self.feld = Array.new(20) { Array.new(20, nil) }
      self.game_objects = []
      init_objectlist
    end

    def draw
      game_objects.each(&:draw)
    end

    private

    def init_objectlist # rubocop:disable Metrics/AbcSize
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
end
