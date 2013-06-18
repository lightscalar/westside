# COLLECTION OF UTILITY METHODS THAT ARE USEFUL ALL OVER THE APPLICATION.

# RETURN THE OBJECT TYPE
@getType = (obj) ->
  return Object.prototype.toString.call(obj).match(/^\[object (.*)\]$/)[1]

@getType = (obj) ->
  if obj == undefined or obj == null
    return String obj
  classToType = new Object
  for name in "Boolean Number String Function Array Date RegExp".split(" ")
    classToType["[object " + name + "]"] = name.toLowerCase()
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"

# DETERMINE IF OBJECT IS A NUMBER
@isNum = (obj) ->
  return getType(obj) is 'number'

# DETERMINE IF OBJECT IS A STRING
@isString = (obj) ->
  return getType(obj) is 'string'

# DETERMINE IF OBJECT IS A STRING
@isArray = (obj) ->
  return getType(obj) is 'array'

# ADD A SENTENCE-CASE METHOD TO THE STRING CLASS
unless String::toSentenceCase
  String::toSentenceCase = () ->
    this.charAt(0).toUpperCase() + this.slice(1)

unless String::trim
  String::trim () ->
    this.replace(/^\s+|\s+$/g, '')

# ADD A PROD METHOD TO THE ARRAY CLASS
unless Array::prod
  Array::prod = () ->
    prod = 1
    for element in this
      prod *= element if isNum(element)
    return prod

# ADD A SUM METHOD TO THE ARRAY CLASS
unless Array::sum
  Array::sum = () ->
    sum = 0
    for element in this
      sum += element if isNum(element)
    return sum

# ADD A MEAN METHOD TO THE ARRAY CLASS
unless Array::mean
  Array::mean = () ->
    return this.sum()/this.length

unless Array::normalize
  Array::normalize = () ->
    total = this.sum()
    temp = []
    for element in this
      element = 1.0 * element/total
      temp.push element
    return temp

# ADD AN EMPTY METHOD TO THE ARRAY CLASS
unless Array::isEmpty
  Array::isEmpty = () ->
    if this.length > 0
      return false
    else
      return true

# ADD A REMOVE ELEMENT METHOD TO THE ARRAY CLASS
  unless Array::remove
    Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

# ADD A CUMSUM method to an array
unless Array::cumsum
  Array::cumsum = () ->
    temp = zeros(this.length)
    idx = 0
    current_sum = 0
    for element in this
      current_sum += element
      temp[idx] = current_sum
      idx += 1
    return temp


# ADD AN isEMPTY FUNCTION FOR OBJECTS
@isEmpty = (object) ->
  for prop of object
    if object.hasOwnProperty(prop)
      return false
  return true

# GENERATE AN ARRAY OF ZEROS
@zeros = (N) ->
  zeros = []
  for iter in [0...N]
    zeros.push 0
  return zeros

# GENERATE AN ARRAY OF ONES
@ones = (N) ->
  ones = []
  for iter in [0...N]
    ones.push 1
  return ones

# GENERATE A RANGE OF INTEGERS
@range = (N) ->
  range = []
  val = 0
  for iter in [0...N]
    range.push val
    val+=1
  return range

# INTERSECTION OF ARRAYS (BEST WAY?)
@intersect = (x,y) ->
  intersection = []
  for xx in x
    for yy in y
      if xx is yy then intersection.push xx
  return intersection

@merge = (a,b,a_key,b_key) ->
  if a.length isnt b.length
    return null
  A = []
  idx = 0
  for idx in range(a.length)
    obj = {}
    obj[a_key] = a[idx]
    obj[b_key] = b[idx]
    A.push obj
  return A

@circshift = (a, delta=1) ->
  delta = -1 * (delta % a.length)
  if delta is 0
    return a
  a = a[delta..].concat(a[0..delta-1])

# ADD AN EMPTY METHOD TO THE ARRAY CLASS
unless Array::contains
  Array::contains = (element) ->
    if getType(element) isnt 'array' then element = [element] # Put it into an array so we may intersect.
    if intersect(this,element).length > 0
      return true
    else
      return false






