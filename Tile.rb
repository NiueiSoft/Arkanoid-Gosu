class Tile
    attr_reader :x, :y, :status
    def initialize(window,tile_location,x,y)
      @image = Gosu::Image.new(window, tile_location, true)
      @x = x
      @y = y
    end
    
    def draw
      @image.draw(@x, @y, 0)
    end
  
    def update()
    end
  end