require "app/vector.rb"


class Game

  attr_gtk

  def tick   
    defaults
    input
    calc
    render
  end 


  def defaults
    BACKGROUND_COLOR ||= {r: 0, g: 48, b: 59}
    CIRCLE_COLOR ||= {r: 255, g: 119, b: 119}
    GRID_COLOR ||= {r: 255, g: 206, b: 150}
    HIGHLIGHT_COLOR ||= {r: 241, g: 242, b: 218}

    CENTER_POINT ||= Vec2D.new(640, 360)
    CIRCLE_LENGTH ||= 300

    state.point ||= Vec2D.new(CIRCLE_LENGTH, 0)

    state.rotation_input ||= false

    state.input_string ||= ""
  end

  def calc
    if state.tick_count == 0
      render_background
    end
  end
  

  def render
    outputs.background_color = BACKGROUND_COLOR.values

    if state.tick_count == 0
      outputs.static_sprites << {
        x: 0,
        y: 0,
        w: 1280,
        h: 720,
        path: :background
      }
    end

    outputs.primitives << {
      primitive_marker: :solid,
      w:  10,
      h:  10,
    }.merge(CENTER_POINT + state.point - [5, 5]).merge(HIGHLIGHT_COLOR)

    render_text(20, 733, "Position: #{state.point.normalize.x.round(2)}, #{state.point.normalize.y.round(2)}", 20)
    render_text(20, 683, "Angle: #{state.point.angle.round}", 20)

    if state.rotation_input
      render_text(20, 633, "Rotate by: ", 20)
      render_text(230, 633, "-", 20) if state.tick_count % 75 > 5 and state.input_string == "-"
      render_text(230, 633, "#{state.input_string} Deg", 20) if state.tick_count % 75 > 5 and !state.input_string.empty? and state.input_string != "-"
    end 

  end

  def input  

    if inputs.keyboard.key_down.r
      state.rotation_input = !state.rotation_input
    end

    if state.rotation_input
      if state.input_string.empty?
        if inputs.text[0] == "-"
          state.input_string += inputs.text[0]
        end
      end
      code = inputs.text[0].ord if inputs.text[0]
      state.input_string += inputs.text[0] if 48 <= code && code <= 57
      state.input_string.chop! if inputs.keyboard.key_down.delete or inputs.keyboard.key_down.backspace
      if inputs.keyboard.key_down.enter
        state.rotation_input = false
        state.point.rotate!(state.input_string.to_i)
        state.input_string = ""
      end
    else
      state.point.rotate!(inputs.up_down)
      if inputs.mouse.button_left
        state.point.set_rotation!((Vec2D.new(inputs.mouse.x, inputs.mouse.y) - CENTER_POINT).angle)
      end
    end

  end

  def render_background
    args.render_target(:background).primitives << {
      primitive_marker: :line,
      x2: 0,
      y2: CENTER_POINT.y + 1
    }.merge(GRID_COLOR).merge(CENTER_POINT + [0, 1])

    args.render_target(:background).primitives << {
      primitive_marker: :line,
      x: CENTER_POINT.x + 1,
      y: 720,
      x2: CENTER_POINT.x + 1,
      y2: 0
    }.merge(GRID_COLOR)

    args.render_target(:background).primitives << {
      primitive_marker: :line,
      x2: 1280,
      y2: CENTER_POINT.y + 1
    }.merge(HIGHLIGHT_COLOR).merge(CENTER_POINT + [0, 1])

    args.render_target(:background).primitives << {
      primitive_marker: :solid,
      w: 3,
      h: 3,
    }.merge(CIRCLE_COLOR).merge(CENTER_POINT - [1, 1])

    point_pos = Vec2D.new(CIRCLE_LENGTH, 0)

    3600.times do
      args.render_target(:background).primitives << {
        primitive_marker: :solid,
        w: 1,
        h: 1,
      }.merge(CIRCLE_COLOR).merge(CENTER_POINT + point_pos)

      point_pos = point_pos.rotate(0.1)
    end
  end

  def render_text(x, y, text, size, direction = "left")
    
    case direction
    when "left"
      alignment = 0
    when "middle"
      alignment = 1
    when "right"
      alignment = 2
    end
  
    text = {x: x,
            y: y,
            primitive_marker: :label,
            text: text,
            size_enum: size,
            alignment_enum: alignment,
            font: "fonts/font.ttf"
    }.merge(GRID_COLOR)
      
    outputs.primitives << text
  end

end


def tick(args)
  $game ||= Game.new
  $game.args = args
  $game.tick
end
