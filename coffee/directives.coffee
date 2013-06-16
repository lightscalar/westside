@directives = angular.module('directives', [])

# An introduction to Sharks & Jets... random motion of these guys.
@directives.directive 'introduction', ->
  restrict: 'A',
  replace: true,
  template: '<div id="introduction"></div>',
  link: (scope, element, attrs) ->
    height = $(element).height()
    width = $(element).width()
    radius = 3
    R2 = radius * radius
    rVisual = 100
    maxNeighbors = 15

    # Preserves the direction of the agent, but adjusts speed to targetSpeed.
    setSpeed = (p, targetSpeed) ->
      norm = Math.sqrt(p.vx*p.vx + p.vy*p.vy)
      p.vx = targetSpeed * p.vx/norm
      p.vy = targetSpeed * p.vy/norm
      return p

    # Define distance function (2-norm).
    distance = (p1, p2) ->
      Math.sqrt(Math.pow(p1.x - p2.x, 2) + Math.pow(p1.y - p2.y, 2))

    # How many members total?
    numMembers = 50

    players = []
    for i in [0...numMembers]
      p =
        x: radius + Math.round(Math.random() * (width-2*radius))
        y: radius + Math.round(Math.random() * (height-2*radius))
        vx: Math.random()
        vy: Math.random()
        gang: Math.round(Math.random())
      p = setSpeed(p, 5)
      players.push p

    # Create a quadtree.
    quadTree = d3.geom.quadtree(players)
    kdtree = new kdTree(players, distance, ['x', 'y'])

    nearestNeighbors = (kdtree, node, R) ->
      neighbors = kdtree.nearest(node, maxNeighbors, R)
      return neighbors

    nodeClick = (node) ->
      # for p in players
      #   console.log p
      #   friends = nearestNeighbors(kdtree, p, 50)
      #   console.log friends
      # console.log 'Number neighbors: ', friends.length-1
      d3.timer(tick)

    svg = d3.select('#introduction').insert('svg:svg').on('click', nodeClick)
    nodes = svg.selectAll('circle').data(players)
    nodes.enter().insert('circle')
      .attr('cx', (d) -> d.x)
      .attr('cy', (d) -> d.y)
      .attr('class', (d) -> if d.gang then 'shark' else 'jet')
      .attr('r', radius)

    tick = ->
      for p in players
        cx = width/2 - p.x
        cy = height/2 - p.y
        # Find neighbors within visual radius
        neighbors = nearestNeighbors(kdtree, p, rVisual)
        numNeighbors = neighbors.length
        numFriends = 0
        numEnemies = 0
        rx = 0
        ry = 0

        # Find the mean velocity & position of neighbors
        friends =
          mvx: 0
          mvy: 0
          mx: 0
          my: 0
          rx: 0
          ry: 0
        enemies =
          mvx: 0
          mvy: 0
          mx: 0
          my: 0
          rx: 0
          ry: 0
        for neighbor in neighbors
          D2 = neighbor[1] * neighbor[1]
          if neighbor[0].gang == p.gang
            numFriends += 1
            friends.mvx += neighbor[0].vx
            friends.mvy += neighbor[0].vy
            friends.mx += neighbor[0].x
            friends.my += neighbor[0].y
            if neighbor[1] < 2*radius
              friends.rx += -(neighbor[0].x - p.x) # (neighbor[0].x - p.x) * Math.exp(-D2/(25*R2))
              friends.ry += -(neighbor[0].y - p.y)
          else
            numEnemies += 1
            enemies.mvx += neighbor[0].vx
            enemies.mvy += neighbor[0].vy
            enemies.mx += neighbor[0].x
            enemies.my += neighbor[0].y
            # enemies.rx += -(neighbor[0].x - p.x) * Math.exp(-D2/(45*R2))
            # enemies.ry += -(neighbor[0].y - p.y) * Math.exp(-D2/(45*R2))
            if neighbor[1] < 10*radius
              enemies.rx += -(neighbor[0].x - p.x) # (neighbor[0].x - p.x) * Math.exp(-D2/(25*R2))
              enemies.ry += -(neighbor[0].y - p.y) # (neighbor[0].y - p.y) * Math.exp(-D2/(25*R2))
        if numFriends > 0
          friends.mvx /= numFriends
          friends.mvy /= numFriends
          friends.mx /= numFriends
          friends.my /= numFriends
        if numEnemies > 0
          enemies.mvx /= numEnemies
          enemies.mvy /= numEnemies
          enemies.mx /= numEnemies
          enemies.my /= numEnemies

        # CENTROID (0) / DIRECTION (1) / INERTIA (2) / RANDOM (3) / FRIENDS (4) / ENEMIES (5)
        coefs = []
        coefs[0] = 1  # centroid
        coefs[1] = 1 # direction
        coefs[2] = 5 # inertia
        coefs[3] = 1  # random
        coefs[4] = 1  # friends
        coefs[5] = 2 # enemies

        centroidForceX = 0
        centroidForceY = 0
        directionForceX = 0
        directionForceY = 0
        repulseX = 0
        repulseY = 0

        if numFriends > 0
          centroidForceX = coefs[0] * ( (friends.mx - p.x))
          directionForceX = coefs[1] * ( (friends.mvx))
          repulseX = coefs[4] * friends.rx
        if numEnemies > 0
          repulseX += coefs[5] * enemies.rx
        inertiaX = coefs[2] * (p.vx)
        randomX = coefs[3] * (Math.random() - 0.5)

        if numFriends > 0
          centroidForceY = coefs[0]   * (friends.my - p.y)
          directionForceY = coefs[1]  * (friends.mvy - p.vy)
          repulseY = coefs[4] * friends.ry
        if numEnemies > 0
          repulseY += coefs[5] * enemies.ry
        inertiaY = coefs[2] * (p.vy)
        randomY = coefs[4] * (Math.random() - 0.5)

        p.vx = inertiaX + centroidForceX + directionForceX + randomX + repulseX
        p.vy = inertiaY + centroidForceY + directionForceY + randomY + repulseY

        p = setSpeed(p, 2+(maxNeighbors - numFriends) * 2.0/maxNeighbors ) # 2+Math.round(2 * Math.random()) )
        # p = setSpeed(p, 2)

        # Update position
        p.x += p.vx
        p.y += p.vy

        if p.x < radius
          p.vx = Math.abs(p.vx)
          p.x = radius
        else if p.x > (width-radius)
          p.vx = -1 * Math.abs(p.vx)
          p.x = width - radius

        if p.y < radius
          p.vy = Math.abs(p.vy)
          p.y = radius
        else if p.y > (height - radius)
          p.vy = -1 * Math.abs(p.vy)
          p.y = height-radius


      d3.selectAll('circle')
        .attr('cx', (d) -> d.x)
        .attr('cy', (d) -> d.y)
      return false

    window.points = players




