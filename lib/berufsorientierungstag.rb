require 'bundler/setup'
require 'berufsorientierungstag/version'

TILESIZE = 40
BORDER = 20
module Berufsorientierungstag
  require 'gosu'
  require 'spielelement/spielelement'
  require 'spielelement/spieler'
  require 'spielelement/repository'

  class MainWindow < Gosu::Window
    def initialize
      super(800, 800)
      self.caption = 'Invision BOT'
      @repo = SpielElementRepository.new
      @repo.import_map('maps/test.json')
      @repo.game_objects << @spieler = Spieler.new(1, 1, repo: @repo)
      # @repo.export_map('maps/')
    end

    def needs_cursor?
      @edit_mode
    end

    def update
      @spieler.call unless @edit_mode
      @edit_mode = !@edit_mode if Gosu.button_down?(Gosu::KbE)
      @repo.edit_mouse_click(mouse_x, mouse_y) \
        if @edit_mode && Gosu.button_down?(Gosu::MsLeft)
    end

    def draw
      @repo.draw_all
    end
  end

  class << self
    def start
      window = MainWindow.new
      window.show
    end
  end
end
