require 'gosu'
require './Tile'

class GameWindow < Gosu::Window
  attr_accessor :punts, :font
  def initialize
    super 640, 480, false
    self.caption = 'ArkaNoob'
    @tiles_location = ['./PNG/01-Breakout-Tiles.png', './PNG/03-Breakout-Tiles.png', './PNG/05-Breakout-Tiles.png',
                       './PNG/07-Breakout-Tiles.png', './PNG/09-Breakout-Tiles.png', './PNG/11-Breakout-Tiles.png', './PNG/13-Breakout-Tiles.png',
                       './PNG/15-Breakout-Tiles.png', './PNG/17-Breakout-Tiles.png', './PNG/19-Breakout-Tiles.png']
    @tiles = []
    @tx = 0
    @ty = 0

    44.times do |time|
      if time < 11
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif time >= 11 && time < 22
        @tx = 0 if @tx >= 660
        @ty = 20
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif time >= 22 && time < 33
        @tx = 0 if @tx >= 660
        @ty = 40
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      elsif time >= 33 && time < 44
        @tx = 0 if @tx >= 660
        @ty = 60
        @tiles.push(Tile.new(self, @tiles_location.sample, @tx, @ty))
      end
      @tx += 60
    end

    @pilota = Pilota.new(self)
    @barraJugador = BarraJugador.new(self)
    @fons = Fons.new(self)
    @foc = Foc.new(self)

    @punts = 0
    @font = Gosu::Font.new(self, Gosu.default_font_name, 20)
  end

  def draw
    @tiles.each(&:draw)
    @pilota.draw
    @barraJugador.draw
    @fons.draw
    @foc.draw
    @font.draw("Punts: #{@punts}", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)
  end

  def update
    if button_down? Gosu::KbLeft
      @barraJugador.x = @barraJugador.x - 5 if @barraJugador.x > 10
    elsif button_down? Gosu::KbRight
      @barraJugador.x = @barraJugador.x + 5 if @barraJugador.x < 520
    end
    collisio_barra(@barraJugador, @pilota)
    collisio_tile(@pilota, @tiles)
    @pilota.update
    @foc.x = @barraJugador.x - 60
    @foc.y = @barraJugador.y - 70
  end
end

def collisio_barra(p_barrajugador, p_pilota)
  if p_pilota.y > 425 && p_pilota.x > p_barrajugador.x && p_pilota.x < p_barrajugador.x + 125
    if @pilota.vy > 0
      @pilota.vy =  @pilota.vy * -1.1
      @pilota.vx =  @pilota.vx * 1.1
      @punts += 10
    end
  end

  if p_pilota.y > 460
    puts 'perdut'
    exit
  end
end

def collisio_tile(p_pilota, tiles)
  tiles.each do |tile|
    unless p_pilota.y > tile.y - 20 && p_pilota.y < tile.y + 20 && tile.x - 30 < p_pilota.x && p_pilota.x < tile.x + 30
      next
    end

    puts "Tile #{tile.x} #{tile.y}, Pilota #{p_pilota.x} #{p_pilota.y}"
    @pilota.vy = @pilota.vy  * -1
    @pilota.vy =  @pilota.vy * 1.02
    @pilota.vx =  @pilota.vx * 1.02
    tiles.delete(tile)
  end
end

class Pilota
  attr_accessor :vx, :vy, :x, :y

  def initialize(window)
    @image = Gosu::Image.new(window, './pilota.bmp', true)
    @x = 500
    @y = 100
    @vx = 1.0
    @vy = 1.0
    @angle = 0
  end

  def draw
    @angle += 5
    @image.draw_rot(@x, @y, 1, @angle, 0.5, 0.5, 0.8, 0.8)
  end

  def update
    @vx *= -1 if @x > 620 || @x < 0
    @vy *= -1 if @y < 0

    @x += 2 * @vx
    @y += 2 * @vy
  end
end

class BarraJugador
  attr_accessor :x, :y

  def initialize(window)
    @image = Gosu::Image.new(window, './barraJugador.jpg', true)
    @x = 500
    @y = 450
  end

  def draw
    @image.draw(@x, @y, 0)
  end
end

class Fons
  attr_accessor :x, :y

  def initialize(window)
    @image = Gosu::Image.new(window, './fons.jpg', true)
    @x = 0
    @y = 0
  end

  def draw
    @image.draw(@x, @y, -1, 0.50, 0.75)
  end
end

class Foc
  attr_accessor :x, :y

  def initialize(_window)
    @image = Gosu::Image.load_tiles 'foc.bmp', 240, 80
    @anima = Animation.new(@image[0..12], 0.1)
    @x = 0
    @y = 0
  end

  def draw
    @anima.start.draw(@x, @y, -1)
  end
end

class Animation
  def initialize(frames, time_in_secs)
    @frames = frames
    @time = time_in_secs * 1000
  end

  def start
    @frames[Gosu.milliseconds / @time % @frames.size]
  end

  def stop
    @frames[0]
  end
end

window = GameWindow.new
window.show
