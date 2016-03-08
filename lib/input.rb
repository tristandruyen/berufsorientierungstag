module Input
  # rubocop:disable Metrics/CyclomaticComplexity
  def button_down(id)
    case id
    when Gosu::MsLeft
      @spielfeld.edit_mouse_click(mouse_x, mouse_y) if @edit_mode
    when Gosu::MsRight
      @spielfeld.edit_mouse_click_right(mouse_x, mouse_y) if @edit_mode
    when Gosu::KbS
      @spielfeld.export_map('maps/') if @edit_mode
    when Gosu::KbE
      @edit_mode = !@edit_mode
    when Gosu::KbC
      require 'pry'
      binding.pry # rubocop:disable Lint/Debugger
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
