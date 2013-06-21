describe 'Sparse Distributed Memory Initialization', ->

  beforeEach ->
    @cortex = new Cortex(1000, {x: 1, y: 1}, 5, 0.8, ['x', 'y'])

  it 'specifies max number of prototypes', ->
    expect(@cortex.maxPrototypes).toEqual 1000

  it 'specifies the learning rate', ->
    expect(@cortex.learningRate).toEqual 0.8

  it 'specifies the minimum number of locations', ->
    expect(@cortex.minLocs).toEqual 5

  it 'specifies the activation radii', ->
    expect(@cortex.activationRadii).toEqual { x : 1, y : 1 }

  it 'determines the vector dimension', ->
    expect(@cortex.vectorDimension).toEqual 2

  it 'saves the state vector dimension labels', ->
    expect(@cortex.dims).toEqual ['x', 'y']


describe 'Similarity and distance', ->

  beforeEach ->
    @cortex = new Cortex(1000, {x: 1, y: 1}, 5, 0.8, ['x', 'y'])

  it 'measures similarity between two identical points', ->
    expect(@cortex.similarity({x:5, y:5}, {x:5, y:5})).toEqual 1

  it 'returns zero for points separated by more than activation radii', ->
    expect(@cortex.similarity({x:10, y:5}, {x:5, y:5})).toEqual 0

  it 'maps between the two extremes', ->
    expect(@cortex.similarity({x:5.2, y:5.4}, {x:5, y:5})).toBeCloseTo 0.6, 0.01

  it 'returns a distance-like measurement as well', ->
    expect(@cortex.triangle({x:5.2, y:5.4}, {x:5, y:5})).toBeCloseTo 1/0.6, 0.01


describe 'Adding a new state/value pair', ->

  beforeEach ->
    @cortex = new Cortex(1000, {x: 1, y: 1}, 3, 0.8, ['x', 'y'])

  it 'throws an exception if vector dimensions do not match', ->
    expect( => @cortex.add({x:1}, 0.4)).toThrow(new Error('Vector dimension must be 2.'))

  it 'adds a new prototype', ->
    @cortex.add({x:3, y:4}, 0.2)
    expect(@cortex.prototypes[0]._value).toBeCloseTo 0.2, 0.01

  it 'accommodates addition of multiple state/value pairs', ->
    @cortex.add({x:3, y:4}, 0.2)
    @cortex.add({x:4.2, y:6.1}, -0.23)
    expect(@cortex.nPrototypes).toBeCloseTo 6, 3

  it 'maps values between multiple points', ->
    @cortex.add({x:3, y:4}, 0.22)
    @cortex.add({x:3.5, y:4.0}, 0.26)
    @cortex.add({x:3.3, y:4.6}, 0.22)
    @cortex.add({x:3.2, y:4.1}, 0.24)
    expect(@cortex.predict({x:3.3, y:4.2})).toBeCloseTo 0.23, 0.1

  it 'only allows for addition of fixed number of prototypes', ->
    @cortex = new Cortex(10, {x: 1, y: 1}, 8, 0.8, ['x', 'y'])
    @cortex.add({x:3, y:4}, 0.2)
    @cortex.add({x:4.2, y:6.1}, -0.23)
    expect(@cortex.nPrototypes).toEqual 10

  it 'handles many dimensions', ->
    dims = ['x', 'y', 'vx', 'vy', 'theta', 'thrust']
    radii = {x: 5, y: 5, vx: 1, vy: 1, theta: 0.5, thrust: 0.3}
    @cortex = new Cortex(1000, radii, 5, 0.4, dims)
    @cortex.predict({x: 100, y: 100, vx: 32, vy: 32, theta: 0.23, thrust: 0.5})






