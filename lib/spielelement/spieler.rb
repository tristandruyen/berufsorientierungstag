class Spieler < SpielElement
  def initialize(*args)
    super(*args)
    @angle = 0
    @feld ||= Array.new(20) { Array.new(20) { { in: Set.new, out: Set.new } } }
  end

  def init
    @file = File.read('bots/template_bot.rb')
    @file.gsub!(/\r\n?/, "\n")
    @line_count = File.foreach('bots/template_bot.rb').inject(0) { |c, _line| c + 1 }
  end

  def call
    @line_num ||= 0
    line = IO.readlines('bots/template_bot.rb')[@line_num]
    proc = proc {}
    eval(line, proc.binding, '') if line

    @line_num += 1
    @line_num %= @line_count
  end

  def vor!
    self.x_pos, self.y_pos = next_pos if vorne_frei?
  end

  def vorne_frei?
    repository.game_objects.each do |obj|
      return false if next_pos == [obj.x_pos, obj.y_pos]
    end
    true
  end

  def dreh_links!(times = 1)
    @angle -= 90 * times
    @angle %= 360
  end

  def dreh_rechts!(times = 1)
    @angle += 90 * times
    @angle %= 360
  end

  def richtung
    @angle
  end

  def speicher
    @feld[x_pos][y_pos]
  end

  def speicher=(value)
    value %= 360
    @feld[x_pos][y_pos] = value unless @feld[x_pos][y_pos].include?(value)
  end

  # ALIASES##################################
  def vor(*args)
    vor!(*args)
  end

  def vorne_frei(*args)
    vorne_frei?(*args)
  end

  def dreh_links(*args)
    dreh_links!(*args)
  end

  def dreh_rechts(*args)
    dreh_rechts!(*args)
  end

  private

  attr_reader :angle

    def init_sprite # rubocop:disable all
      @sprite = Gosu.record(TILESIZE, TILESIZE) do
        Gosu.draw_rect(TILESIZE / 10, TILESIZE / 10,
                       TILESIZE * 7 / 10, TILESIZE * 9 / 10,
                       random_color)
        draw_triangle(TILESIZE / 10, TILESIZE / 10, random_color,
                      TILESIZE * 9 / 10, TILESIZE / 2, random_color,
                      TILESIZE / 10, TILESIZE + 9 / 10, random_color)
      end
    end

  # rubocop:disable Metrics/ParameterLists
  def draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3)
    Gosu.draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x3, y3, c3)
  end
  # rubocop:enable Metrics/ParameterLists

  def next_pos
    x_mov, y_mov = 0, 0 # rubocop:disable Style/ParallelAssignment
    case angle
    when 0 then x_mov = 1
    when 90 then y_mov = 1
    when 180 then x_mov = -1
    when 270 then y_mov = -1
    end
    [x_pos + x_mov, y_pos + y_mov]
  end
  end
