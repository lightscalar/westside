describe 'The getType function', ->

  it 'returns the String type when called on a String', ->
    type = getType("Cats blow.")
    expect(type).toEqual 'string'

  it 'returns a number when called on an integer', ->
    type = getType(5)
    expect(type).toEqual 'number'

  it 'returns a number when called on a float', ->
    type = getType(5.5)
    expect(type).toEqual 'number'

describe 'The isNum function', ->

  it 'returns true for integers', ->
    expect(isNum(2)).toEqual true

  it 'returns true for floats', ->
    expect(isNum(3.1415)).toEqual true

  it 'returns false for Strings', ->
    expect(isNum('The Number Four')).toEqual false

describe 'The isString function', ->

  it 'returns true for strings', ->
    expect(isString('My Name is Cthulu!')).toEqual true

  it 'returns false for numbers', ->
    expect(isString(5.4)).toEqual false

describe 'The sentence capitalization method', ->

  it 'properly capitalizes a sentence', ->
    better = 'i walked my dog.'.toSentenceCase()
    expect(better).toEqual 'I walked my dog.'

describe 'The product method', ->

  it 'computes the product of an array of numbers', ->
    testArray = [1,2,3,4]
    product = testArray.prod()
    expect(product).toEqual 24

  it 'even works on heterogeneous arrays', ->
    testArray = [1,'two',3,'four']
    expect(testArray.prod()).toEqual 3

describe 'The sum method', ->

  it 'computes the sum of the numbers in an array', ->
    testArray = [1,2,3,4]
    expect(testArray.sum()).toEqual 10

  it 'even works on heterogenous arrays', ->
    testArray = [1,'two',3,'four']
    expect(testArray.sum()).toEqual 4

describe 'The empty method', ->

  it 'returns true is an array is empty', ->
    testArray = []
    expect(testArray.isEmpty()).toEqual true

  it 'returns false when the array is populated', ->
    testArray = ['string content']
    expect(testArray.isEmpty()).toEqual false

describe 'The normalize method', ->

  it 'normalizes an array array of numbers so they sum to unity', ->
    testArray = [80,10,10]
    expect(testArray.normalize()).toEqual [.8, 0.1, 0.1]

describe 'The zeros utility', ->

  it 'returns an array containing the requested number of zeros', ->
    expect(zeros(5)).toEqual [0,0,0,0,0]

describe 'The ones utility', ->

  it 'returns an array containing the requested number of zeros', ->
    expect(ones(5)).toEqual [1,1,1,1,1]

describe 'The remove utility', ->

  it 'removes the specified element from an array', ->
    obj1 = {id:1}
    obj2 = {id:2}
    obj3 = {id:3}
    myArray = [obj1, obj2, obj3]
    myArray.remove(obj2)
    expect(myArray).toEqual [obj1, obj3]

describe 'The string trim function', ->

  it 'trims leading spaces', ->
    expect('   Leading space'.trim()).toEqual 'Leading space'

  it 'trims trailing spaces', ->
    expect('Trailing space   '.trim()).toEqual 'Trailing space'

  it 'trims both leading and trailing space', ->
    expect('   trailing & leading space   '.trim()).toEqual 'trailing & leading space'

describe 'The intersection utility', ->

  it 'returns the common elements of two arrays', ->
    x = ['milk', 'eggs', 'coffee']
    y = ['coffee', 'blood diamonds', 'milk']
    expect(intersect(x,y)).toEqual ['milk', 'coffee']

  it 'returns an empty set if there is no intersection', ->
    x = [1,2,3]
    y = [4,5,6]
    expect(intersect(x,y)).toEqual []

describe 'The contains array method', ->

  it 'returns a boolean indicating whether it contains specified element', ->
    x = ['milk', 'eggs', 'coffee']
    expect(x.contains('eggs')).toEqual true

  it 'returns false if the array does not contain that object', ->
    x = ['milk', 'eggs', 'coffee']
    expect(x.contains('blood diamonds')).toEqual false

describe 'The discrete sampling function', ->

  it 'draws from'
















