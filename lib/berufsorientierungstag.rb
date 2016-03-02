require 'bundler/setup'
require 'berufsorientierungstag/version'

module Berufsorientierungstag
  require 'gosu'
  require 'spielfeld'

  class MainWindow < Gosu::Window
    def initialize
      super(800, 800)
      self.caption = 'Hello World!'
      @feld = Spielfeld.new
    end

    def update
    end

    def draw
      @feld.draw
    end
  end

  class << self
    def start
      window = MainWindow.new
      window.show
    end
  end
end
