require 'gosu'
class WhackARuby < Gosu::Window
  def initialize
    super(800, 600)
    self.caption  = 'Whack the Ruby!!!'
    @image        = Gosu::Image.new('ruby.png')
    @hammer_image = Gosu::Image.new('hammer.png')
    @iphone_image = Gosu::Image.new('iphone.png')

    @x            = 200
    @y            = 200
    # width and height of the Ruby picture
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
    @x1           = 400
    @y1           = 400
    @velocity_x1  = 3
    @velocity_y1  = 3
    @iphone_width = 150
    @iphone_height = 85
  end

  def draw
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    # - width and height of the hammer picture so that the hammer is centered roughly at the position of the mouse
    @hammer_image.draw(mouse_x - 150, mouse_y - 150, 1)
    @iphone_image.draw(@x1 - @iphone_width / 2, @y1 - @iphone_height / 2, 1) if @playing
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
    if Gosu.distance(@x, @y, @x1, @y1) < 100 && @visible > 0 && @playing
      draw_quad(0, 0, Gosu::Color::WHITE, 800, 0, Gosu::Color::WHITE, 800, 600, Gosu::Color::WHITE, 0, 600, Gosu::Color::WHITE)
    end
  end

  def update
    if @playing
      @velocity_x *= -1 if (@x + @width / 2) > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @velocity_x1 *= -1 if (@x1 + @iphone_width / 2) > 800 || @x1 - @iphone_width / 2 < 0
      @x          += @velocity_x
      @y          += @velocity_y
      @x1         += @velocity_x1
      @visible    -= 1
      @visible     = 40 if @visible < -10 && rand < 0.1
      @time_left   = (100 - ((Gosu.milliseconds - @start_time) * 0.001)).to_i
      @playing     = false if @time_left <= 0
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