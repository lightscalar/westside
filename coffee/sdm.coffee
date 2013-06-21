# Sparse Distributed Memory for Reinforcement Learning.

@Cortex = class Cortex

  constructor: (@maxPrototypes, @activationRadii, @minLocs, @learningRate, @dims) ->
    # Define maximum allowed similarity between two input vectors.
    if @minLocs >= 3
      @maxSimilarity = 1.0 - 1.0/(@minLocs-1)
    else
      @maxSimilarity = 0.5

    # All state vectors presented must be of same dimension.
    @vectorDimension = (key for key,value of @activationRadii).length

    # Initialize prototypes & values.
    @prototypes = []
    @nPrototypes = 0

    @similarity = (p1, p2) ->
      similarity = 1
      for key of p1
        if key == '_value' then continue
        d = Math.abs(p1[key] - p2[key])
        if d < @activationRadii[key]
          tmp = 1 - d/@activationRadii[key]
          if tmp <= similarity
            similarity = tmp
        else return 0
      return similarity

    @triangle = (p1, p2) =>
      return 1/@similarity(p1, p2)

    # Initialize the KD-tree for fast retrieval.
    @tree = new kdTree(@prototypes, @triangle, @dims)


  add: (state, value) ->
    # Ensure that vector has the proper dimension.
    if (key for key of state).length != @vectorDimension
      throw('Vector dimension must be ' + @vectorDimension + '.')

    if @sparseEnough(state)
      @addPrototype(state, value)
      @randState(state)

    # Find this prototypes current active set.
    activeSet = @activeSet(state)

    # Make sure enough locations are lit up.
    while activeSet.length < @minLocs
      randomState = @randState(state)
      predictedValue = @predict(state)
      randomState._value = predictedValue
      if @sparseEnough(randomState)
        @addPrototype(randomState, predictedValue)
        activeSet = @activeSet(state)



  addPrototype: (state, value) ->
    # Make sure we are not exceeding prototype limit.
    if @nPrototypes >= @maxPrototypes
      @removePrototype()
    # Add current state/value pair to the network.
    state['_value'] = value
    @prototypes.push(state)
    @nPrototypes += 1
    @updateTree()
    @updatePrototypes(state, value)


  updatePrototypes: (state, value) ->
    predictedValue = @predict(state)
    activeSet = @activeSet(state)
    denom = 0
    for p in activeSet
      denom += 1/p[1]
    for p in activeSet
      p[0]._value = p[0]._value + @learningRate/denom * (value - predictedValue)


  randState: (state) ->
    newState = {}
    for own key of state
      newState[key] = state[key] + 2 * (Math.random() - 0.5) * @activationRadii[key]
    return newState


  # Predict the value of a given state.
  predict: (state) ->
    if @nPrototypes == 0 then return 0
    activeSet = @activeSet(state)
    if activeSet.length == 0 then return 0
    denom = 0
    numer = 0
    for p in activeSet
      denom += 1/p[1]
      numer += 1/p[1] * p[0]._value
    return numer/denom


  sparseEnough: (state) ->
    if @nPrototypes == 0 then return true
    nearestNeighbor = @tree.nearest(state, 1, 100)
    if nearestNeighbor.length == 0 then return true
    # Check to see if nearest neighbor is too close.
    @similarity(state, nearestNeighbor) < @maxSimilarity


  removePrototype: ->
    target = Math.floor(Math.random() * @nPrototypes)
    p = @prototypes[target]
    nearestNeighbor = @tree.nearest(p, 1, 100)
    # Replace the value of the target with the average of its closest neighbor.
    for key in p
      nearestNeighbor[0][key] = (nearestNeighbor[0][key] + p[key])/2
    @prototypes.remove(p)
    @nPrototypes -= 1


  updateTree: ->
    @tree = new kdTree(@prototypes, @triangle, @dims)


  activeSet: (state) ->
    return @tree.nearest(state, @minLocs*2, 100)

