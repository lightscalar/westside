@Learn = class Learn

  constructor: (@nStates, @nActions, @gamma = 1.0, @alpha = 0.6, @lambda = 0.9) ->
    @Q = []
    @E = []
    @stateActionList = []
    for actionIter in [0...@nActions]
      state = zeros(@nStates.length)
      stateMatrix = {}
      eligibilityMatrix = {}
      for iter in [0... @nStates.prod()]
        stateMatrix[state] = 10 * Math.random()
        eligibilityMatrix[state] = 0
        state = @incrementState(state)
      @Q.push stateMatrix
      @E.push eligibilityMatrix


  incrementState: (state) ->
    for i in [0...state.length]
      if state[i] < (@nStates[i] - 1)
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


  # Maintain the state/action list
  addToUpdateList: (action, state) ->
    if @stateActionList.length > 100
      L = @stateActionList.length - 100
      @stateActionList = @stateActionList[L..]
    @stateActionList.push {action: action, state: state}



  # Update our Q function using SARSA w/ eligibility traces.
  sarsa: (actionTaken, oldState, newState, reward) ->
    newAction = @selectAction(newState)
    delta = reward + @gamma * @Q[newAction][newState] - @Q[actionTaken][oldState]
    @E[actionTaken][oldState] += 1
    @addToUpdateList(actionTaken, oldState)
    for q in @stateActionList
      @Q[q.action][q.state] += @alpha * delta * @E[q.action][q.state]
      @E[q.action][q.state] = @gamma * @lambda * @E[q.action][q.state]
    return newAction


  # Update our Q function based on the observations
  update: (actionTaken, oldState, newState, reward) ->
    bestQ = @maxAction(newState)
    try
      @Q[actionTaken][oldState] += @alpha * (reward + @gamma * bestQ - @Q[actionTaken][oldState])
    catch error
      console.log 'Error'
      console.log 'The action taken was: ', actionTaken

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
      if bestAction < 0
        window.Q = @Q
        window.state = state
        throw 'Hello no!'
      return bestAction
    else
      # Just select a random action.
      return Math.floor(Math.random() * @nActions)

