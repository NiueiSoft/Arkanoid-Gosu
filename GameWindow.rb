require 'gosu'
 
class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Mi primer juego"
    @player = Player.new(self)
  end
 
  def draw
    @player.draw
  end

  def update
    if button_down? Gosu::KbDown
      @player.vy=@player.vy*(-1)
    end
    @player.update
  end

end
 
class Player
  attr_accessor :vx,:vy
  
  def initialize(window)
    @image = Gosu::Image.new(window, "./pilota.jpg", true)
    @x = 500
    @y = 100
    @vx = 1
    @vy = 1
  end
  
  def draw()
    @image.draw(@x, @y, 0)
  end

  def update()
    if (@x >540 || @x<0)
      @vx = @vx*-1
    end
    if (@y >380 || @y<0)
      @vy = @vy*-1
    end
    
    
    @x = @x + 2*@vx
    @y = @y + 2*@vy
    
  end
end
 
window = GameWindow.new
window.show