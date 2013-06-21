@directives = angular.module('directives', [])

# An introduction to Sharks & Jets... random motion of these guys.
@directives.directive 'westside', ->
  restrict: 'A',
  replace: true,
  template: '<div id="westside" class="westside"></div>',
  link: (scope, element, attrs) ->

    # Define parameters
    width = $(element).width()
    height = 400
    numAgents = 50
    stopSimulation = true
    alpha = 0.6
    epsilon = 0.1
    agents = []

    Q = new Learn([30, 30, 2], 5)

    # Build the kd-tree.
    tree = new kdTree(agents, distance, ['x', 'y'])

    # Add an SVG canvas.
    svg = d3.select('#westside').insert('svg:svg')
            .attr('width', width)
            .attr('height', height)

    # Define a target.
    svg.append('circle')
      .attr('class', 'jets')
      .attr('cx', 0.75 * width)
      .attr('cy', 0.5 * height)
      .attr('r', 100)
      .attr('stroke', '#7f8c8d')
      .attr('stroke-width', 2)
      .attr('fill', '#efefef')
      .attr('opacity', 0.8)

    svg.append('circle')
      .attr('class', 'sharks')
      .attr('cx', 0.25 * width)
      .attr('cy', 0.5 * height)
      .attr('r', 100)
      .attr('stroke', '#7f8c8d')
      .attr('stroke-width', 2)
      .attr('fill', '#efefef')
      .attr('opacity', 0.8)

    # Define the agents.
    agent = svg.selectAll('circle.agent')

    dragmove = ->
      d3.select(this)
        .attr('cx', (d) -> d.x = d3.event.x)
        .attr('cy', (d) -> d.y = d3.event.y)

    drag = d3.behavior.drag()
        .on("drag", dragmove);


    redraw = ->
      # Add circles to represent each agent.
      theAgents = agent.data(agents)
      theAgents.enter().insert('circle')
        .attr('class', 'agent')
        .attr('cx', (d) -> d.x)
        .attr('cy', (d) -> d.y)
        .attr('r', (d) -> d.radius)
        .attr('class', (d) -> if d.gang then 'agent shark' else 'agent jet')
        .call(drag)


    reset = ->
      # Remove all agents from the picture.
      agents = []
      svg.selectAll('circle.agent').data([]).exit().remove()
      for index in [0...numAgents]
        agents.push new Agent(index, width, height, 6)
      tree = new kdTree(agents, distance, ['x', 'y'])
      window.tree = tree
      redraw()


    tick = ->
      # Update position of agents in the simulation.
      for a in agents
        oldState = a.state()
        selectedAction = a.takeNextAction()
        # a.takeAction(selectedAction)
        newState = a.update()
        a.nextAction = Q.sarsa(selectedAction, oldState, newState, a.reward())

      # Draw the new position of the agent on the canvas.
      svg.selectAll('circle.agent')
        .attr('cx', (d) -> d.x)
        .attr('cy', (d) -> d.y)
      return stopSimulation


    toggleSimulation = ->
      stopSimulation = !stopSimulation
      if !stopSimulation
        d3.timer(tick)

    # Reset the simulation!
    reset()

    # Let user reset.
    svg.on('dblclick', reset)
    svg.on('click', toggleSimulation)



