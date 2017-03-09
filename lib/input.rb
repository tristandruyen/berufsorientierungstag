module Input
  def button_down(id)
    case id
    when Gosu::KbS
      @spielfeld.export_map('maps/')
    when Gosu::KbE
      @spielfeld.toggle_edit
    when Gosu::KbReturn
      @spielfeld.toggle_edit
    when Gosu::KbN
      @spielfeld = Spielfeld.new
      @spielfeld.import_map(@maps.first)
      @maps.rotate!
    when Gosu::KbR
      @spielfeld = Spielfeld.new
      @spielfeld.import_map(@maps.last)
    when Gosu::KbP
      @maps.rotate!(-1)
      @spielfeld = Spielfeld.new
      @spielfeld.import_map(@maps.last)
      # when Gosu::MsLeft
      #   @spielfeld.edit_mouse_click(mouse_x, mouse_y)
      # when Gosu::MsRight
      # @spielfeld.edit_mouse_click_right(mouse_x, mouse_y)
      # when Gosu::KbC
      #   require 'pry'
      #   binding.pry # rubocop:disable Lint/Debugger
    end
  end
end
