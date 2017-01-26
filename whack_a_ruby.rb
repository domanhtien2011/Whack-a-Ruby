require 'gosu'
class WhackARuby < Gosu::Window
  def initialize
    super(800, 600)
    self.caption  = 'Whack the Ruby!!!'
    @image        = Gosu::Image.new('ruby.png')
    @hammer_image = Gosu::Image.new('hammer.png')

    @x            = 200
    @y            = 200
    # width and height of the picture
    @width        = 300
    @height       = 300
    @velocity_x   = 5
    @velocity_y   = 5
    @visible      = 0
    @hit          = 0
    @font         = Gosu::Font.new(30)
    @score        = 0
    @playing      = true
    @start_time   = 0
  end

  def draw
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    # - width and height of the hammer picture so that the hammer is centered roughly at the position of the mouse
    @hammer_image.draw(mouse_x - 150, mouse_y - 150, 1)
    case @hit
      when 0
        c = Gosu::Color::NONE
      when 1
        c = Gosu::Color::GREEN
      when -1
        c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    @font.draw(@score.to_s, 700, 20, 2)
    @font.draw(@time_left .to_s, 20, 20, 2)
    unless @playing
      @font.draw('Game Over!', 300, 300, 3)
      @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
      @visible = 20
    end
  end

  def update
    if @playing
      @velocity_x *= -1 if (@x + @width / 2) > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @x          += @velocity_x
      @y          += @velocity_y
      @visible    -= 1
      @visible     = 40 if @visible < -10 && rand < 0.01
      @time_left   = (50 - ((Gosu.milliseconds - @start_time) * 0.001)).to_i
      @playing     = false if @time_left < 0
    end
  end

  def button_down(id)
    if @playing
      if id == Gosu::MS_LEFT
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 100 && @visible > 0
          @score += 5
          @hit = 1
        else
          @score -= 1
          @hit = -1
        end
      end
    else
      if (id == Gosu::KB_SPACE)
        @playing    = true
        @visible    = -10
        @start_time = Gosu.milliseconds
        @score      = 0
      end
    end
  end
end

window = WhackARuby.new
window.show