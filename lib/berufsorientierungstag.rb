require 'bundler/setup'
require 'berufsorientierungstag/version'
require_relative '../bots/template_bot.rb'

TILESIZE = 40
BORDER = TILESIZE / 2
WIDTH = 800
HEIGHT = 800
ROWS_ON_SCREEN = WIDTH / TILESIZE
module Berufsorientierungstag
  require 'gosu'
  require 'spielelement/spielelement'
  require 'spielelement/spieler'
  require 'spielfeld'
  require 'input'

  class MainWindow < Gosu::Window
    include Input
    def initialize
      super(800, 800)
      self.caption = 'Invision BOT'
      @spielfeld = Spielfeld.new
      # @spielfeld.import_map('maps/default_map.json')
      @spielfeld.import_map('maps/bot_hard1_map.json')
      @speed = 5
    end

    def needs_cursor?
      @edit_mode
    end

    def update
      handle_game_state
    end

    def handle_game_state
      every_n_times(5) do
        @spielfeld.call_all
      end unless @edit_mode
    end

    def draw
      @spielfeld.draw_all
    end

    def every_n_times(n)
      @every_n_times_count ||= 0
      yield if (@every_n_times_count % n) == 0
      @every_n_times_count += 1
    end
  end

  class << self
    def start
      window = MainWindow.new
      window.show
    end
  end
end
