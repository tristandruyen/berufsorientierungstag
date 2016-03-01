require "berufsorientierungstag/version"

module Berufsorientierungstag
  require 'gosu'

  class MainWindow < Gosu::Window
    def initialize
      super(800, 600)
      self.caption = 'Hello World!'
    end

    def update
    end

    def draw
    end
  end

  class << self
    def start
      window = MainWindow.new
      window.show
    end
  end
end
