class Vec2D

  attr_accessor :x, :y

  def initialize(x, y = nil)
    if y
      @x = x
      @y = y
    else
      @x = x[0]
      @y = x[1]
    end
  end

  def [](i)
    return @x if i == 0
    return @y if i == 1

    raise ArgumentError, "Can only index Vec2D with 0 or 1"
  end

  def +(other_vector)
    return Vec2D.new(x + other_vector.x, y + other_vector.y)
  end

  def -(other_vector)
    return Vec2D.new(x - other_vector.x, y - other_vector.y)
  end

  def to_s
    return "[" + @x.to_s + ", " + @y.to_s + "]"
  end

  def as_hash
    return {x: @x, y: @y}
  end

  def length
    return Math.hypot(@x, @y)
  end

  def angle 
    degrees = -(Math.atan2(@y, @x) * 57.2957795)
    return degrees if degrees >= 0
    return degrees + 360
  end

  def normalize
    return Vec2D.new(0, 0) if [@x, @y] == [0, 0]     
    return Vec2D.new(@x/self.length, @y/self.length)
  end

  def normalize!
    unless [@x, @y] == [0, 0]
      @x /= self.length
      @y /= self.length
    end

    return self 
  end

  def rotate(degrees)
    degrees = -degrees/57.2957795

    x = @x * Math.cos(degrees) - @y * Math.sin(degrees)
    y = @x * Math.sin(degrees) + @y * Math.cos(degrees)

    return Vec2D.new(x, y)
  end

  def rotate!(degrees)
    degrees = -degrees/57.2957795

    x = @x * Math.cos(degrees) - @y * Math.sin(degrees)
    y = @x * Math.sin(degrees) + @y * Math.cos(degrees)

    @x = x
    @y = y

    return self
  end

  def set_rotation(degrees)
    degrees = -degrees/57.2957795

    x = self.length * Math.cos(degrees)
    y = self.length * Math.sin(degrees)

    return Vec2D.new(x, y)
  end

  def set_rotation!(degrees)
    degrees = -degrees/57.2957795

    x = self.length * Math.cos(degrees)
    y = self.length * Math.sin(degrees)
    @x = x
    @y = y

    return self
  end
end
