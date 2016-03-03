require 'bundler/setup'
require 'berufsorientierungstag/version'

TILESIZE = 40
BORDER = 17.5
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
      @repo.export_map('maps/')
    end

    def update
      @spieler.call
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
