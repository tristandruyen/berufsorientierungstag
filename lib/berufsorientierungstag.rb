require 'bundler/setup'
require 'berufsorientierungstag/version'

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
      @repo.game_objects << @spieler = Spieler.new(1, 1, repo: @repo)
    end

    def update
      @spieler.vor!
      @spieler.dreh_rechts! unless @spieler.vorne_frei?
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
