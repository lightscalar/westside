@Agent = class Agent
  # An intelligent agent.

  constructor: (@index, @width, @height, @radius = 2, @gang = null) ->
    # Mass of the agent is area of agent times agent density (which is 1 kg/m^2).
    # ---
    #   index - integer
    #     Unique identifying ID for the agent.
    #   width - integer
    #     The width of Westside, in pixels.
    #   height - integer
    #     The height of Westside, in pixels.
    #   radius - integer
    #     The radius of the agent, in pixels.
    #   gang - integer
    #     The gang ID of the agent -- 0 for jets, 1 for sharks.
    @dthrust = 0.75
    @dtheta = Math.PI/16
    @mu = 6e-2
    @discretization = 30


    # Calculate the mass of the agent, based on its size (constant areal density).
    @mass = 0.2 * @radius


    # Positions are initially uniformly distributed across Westside.
    @x = @radius + Math.round(Math.random() * ( @width - 2*@radius))
    @y = @radius + Math.round(Math.random() * (@height - 2*@radius))

    # Velocity of each agent is initially zero.
    @vx = 0
    @vy = 0

    # The agent's gang identity.
    @gang = if !@gang? then Math.round(Math.random()) else @gang

    # Initialize thrust and thrust angle.
    @theta = 2*Math.PI * Math.random()
    @thrust = 0

    # Set the agent's thrust to zero.
    @horzThrust = 0
    @vertThrust = 0

  takeAction: (action = null) ->
    # Take one of the four possible actions:
    # ---
    #   0: do nothing
    #   1: increase thrust
    #   2: decrease thrust
    #   3: rotate thrust vector clockwise
    #   4: rotate thrust vector counter-clockwise
    if !action?
      action = Math.round(4 * Math.random())
    switch action
      when 1 then @vertThrust = @dthrust
      when 2 then @vertThrust = -@dthrust
      when 3 then @horzThrust = @dthrust
      when 4 then @horzThrust = -@dthrust
      when 0
        @vertThrust = 0
        @horzThrust = 0
    # if !action?
    #   action = Math.round(4 * Math.random())
    # switch action
    #   when 1 then @theta  += @dtheta % 2*Math.PI
    #   when 2 then @theta  -= @dtheta % 2*Math.PI
    #   when 3 then @thrust = @dthrust
    #   when 4 then @thrust = 0
    #   # when 0 change nothing


  state: ->
    return [Math.floor(@x/@width * (@discretization-1)), Math.floor(@y/@height * (@discretization-1)), @gang]
    # return {x: @x, y: @y, vx: @vx, vy: @vy, theta: @theta, thrust: @thrust}

  reward: ->
    pos = {x: @x, y: @y}
    jetTarget = {x: @width * 0.75, y: @height* 0.5}
    sharkTarget = {x: @width * 0.25, y: @height* 0.5}
    if distance(pos, sharkTarget) < 100
      # console.log 'SHARK'
      switch @gang
        when 0 then return -100
        when 1 then return 100
    else if distance(pos, jetTarget) < 100
      # console.log 'JET'
      switch @gang
        when 0 then return 100
        when 1 then return -100
    else
      return -1


  update: (tree) ->
    # Update the position of the agent based on the current force, velocity, and position.
    # ---
    #   tree - a KD-tree holding information about position of all other particles.

    # First, update the velocity based on the current thrust.
    @vx += @horzThrust
    @vy += @vertThrust
    # @vx += @thrust * Math.cos(@theta)
    # @vy += @thrust * Math.sin(@theta)

    # Now add friction, proportional to square of velocity.
    @vx += -1 * sgn(@vx) * @mu * @vx*@vx
    @vy += -1 * sgn(@vy) * @mu * @vy*@vy

    # @vx = @vx / @mass
    # @vy = @vy / @mass

    # Finally, update the position based on the velocity.
    @x += @vx
    @y += @vy

    # Agents must not leave Westside.
    if @x < @radius
      @x = @radius
      @vx = Math.abs(@vx)
    else if @x > @width - @radius
      @x = @width - @radius
      @vx = -1 * Math.abs(@vx)

    if @y < @radius
      @y = @radius
      @vy = Math.abs(@vy)
    else if @y > @height - @radius
      @y = @height - @radius
      @vy = -1 * Math.abs(@vy)




