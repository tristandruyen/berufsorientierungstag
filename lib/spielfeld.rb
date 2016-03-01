# coding: utf-8

module Berufsorientierungstag
  class Spielfeld
    def initialize
      @feld = Array.new(3) { Array.new(3,0) }
    end

    def update
      puts @feld
    end

    def draw
    end
  end
end
