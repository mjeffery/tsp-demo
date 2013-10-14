angular.module('tsp-demo')
  .factory 'Node', () ->
    RADIUS = 5
    CHANGE_RATE = RADIUS / 250

    class Node
      constructor: (@x, @y) ->
        @radius = 0
        @state = 'expanding'
    
      destroy: () -> @state = 'contracting' if @state isnt 'destroyed'
       
      isDestroyed: () -> @state is 'destroyed'
    
      contains: (x, y) ->
        dx = @x - x
        dy = @y - y
        Math.abs(dx) <= @radius and
        Math.abs(dy) <= @radius and
        dx*dx + dy*dy <= @radius * @radius
        
      update: (dt) ->
        switch @state
          when 'expanding' 
            @radius += dt * CHANGE_RATE
            if @radius >= RADIUS
              @radius = RADIUS
              @state = 'expanded'
          when 'contracting'
            @radius -= dt * CHANGE_RATE
            if @radius <= 0
              @radius = 0
              @state = 'destroyed'
              
      draw: (ctx) ->
        if @radius > 0
          ctx.fillStyle = 'black'
          ctx.beginPath()
          ctx.arc @x, @y, @radius, 0, 2 * Math.PI
          ctx.closePath()
          ctx.fill()
