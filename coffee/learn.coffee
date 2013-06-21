@Learn = class Learn

  constructor: (@nStates, @nActions, @gamma = 0.5, @alpha = 0.6) ->
    @Q = []
    for actionIter in [0...@nActions]
      state = zeros(@nStates.length)
      stateMatrix = {}
      for iter in [0... @nStates.prod()]
        stateMatrix[state] = 10 * Math.random()
        state = @incrementState(state)
      @Q.push stateMatrix


  incrementState: (state) ->
    for i in [0...state.length]
      if state[i] < @nStates[i]
        state[i] += 1
        for j in [0...i]
          state[j] = 0
        return state
    return state

  maxAction: (state) ->
    bestFitness = -Infinity
    for a in [0...@nActions]
      if @Q[a][state] > bestFitness
        bestFitness = @Q[a][state]
    return bestFitness


  # Update our Q function based on the observations
  update: (actionTaken, oldState, newState, reward) ->
    bestQ = @maxAction(newState)
    try
      @Q[actionTaken][oldState] += @alpha * (reward + @gamma * bestQ - @Q[actionTaken][oldState])
    catch error
      console.log 'Error'
      console.log actionTaken, oldState[0], oldState[1], reward

  # Epsilon greedy selection of available actions.
  selectAction: (state, epsilon=0) ->
    if Math.random() > epsilon
      # Select the action with highest action/value.
      bestFitness = -Infinity
      bestAction = -1
      for action in [0...@nActions]
        if @Q[action][state] > bestFitness
          bestAction = action
          bestFitness = @Q[action][state]
      return bestAction
    else
      # Just select a random action.
      return Math.floor(Math.random() * @nActions)

