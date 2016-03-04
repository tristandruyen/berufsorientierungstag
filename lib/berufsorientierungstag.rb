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
      # TODO: Refactor class so that the repo stores player inside own var
      @spieler = Spieler.new(1, 1, repo: @repo)
      # @repo.export_map('maps/')
    end

    def needs_cursor?
      @edit_mode
    end

    def update
      @edit_mode = !@edit_mode if Gosu.button_down?(Gosu::KbE)

      if @edit_mode
        if Gosu.button_down?(Gosu::MsLeft)
          @repo.edit_mouse_click(mouse_x, mouse_y)
        elsif Gosu.button_down?(Gosu::MsRight)
          @repo.edit_mouse_click_right(mouse_x, mouse_y)
        elsif Gosu.button_down?(Gosu::KbS)
        end
      else
        @spieler.each.call
      end
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
