require "gosu"
require "./Tile"

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Mi primer juego"
    @player = Player.new(self)
    @tiles_location = ["./PNG/01-Breakout-Tiles.png", "./PNG/03-Breakout-Tiles.png", "./PNG/05-Breakout-Tiles.png",
                       "./PNG/07-Breakout-Tiles.png", "./PNG/09-Breakout-Tiles.png", "./PNG/11-Breakout-Tiles.png", "./PNG/13-Breakout-Tiles.png",
                       "./PNG/15-Breakout-Tiles.png", "./PNG/17-Breakout-Tiles.png", "./PNG/19-Breakout-Tiles.png"]
    @tiles = []
    @tx = 0
    @ty = 0

    44.times do |time|
      if (time < 11)
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif (time >= 11 && time < 22)
        if (@tx >= 660)
          @tx = 0
        end
        @ty = 20
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif (time >= 22 && time < 33)
        if (@tx >= 660)
          @tx = 0
        end
        @ty = 40
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif (time >= 33 && time < 44)
        if (@tx >= 660)
          @tx = 0
        end
        @ty = 60
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      end
      @tx += 60
    end
  end

  def draw
    @player.draw
    @tiles.each do |tile|
      tile.draw
    end
  end

  def update
    if button_down? Gosu::KbDown
      @player.vy = @player.vy * (-1)
    end
    @player.update

  end
end

class Player
  attr_accessor :vx, :vy

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
    if (@x > 540 || @x < 0)
      @vx = @vx * -1
    end
    if (@y > 380 || @y < 0)
      @vy = @vy * -1
    end

    @x = @x + 2 * @vx
    @y = @y + 2 * @vy
  end
end

window = GameWindow.new
window.show
