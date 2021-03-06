// Generated by CoffeeScript 1.3.3
(function() {

  describe('The getType function', function() {
    it('returns the String type when called on a String', function() {
      var type;
      type = getType("Cats blow.");
      return expect(type).toEqual('string');
    });
    it('returns a number when called on an integer', function() {
      var type;
      type = getType(5);
      return expect(type).toEqual('number');
    });
    return it('returns a number when called on a float', function() {
      var type;
      type = getType(5.5);
      return expect(type).toEqual('number');
    });
  });

  describe('The isNum function', function() {
    it('returns true for integers', function() {
      return expect(isNum(2)).toEqual(true);
    });
    it('returns true for floats', function() {
      return expect(isNum(3.1415)).toEqual(true);
    });
    return it('returns false for Strings', function() {
      return expect(isNum('The Number Four')).toEqual(false);
    });
  });

  describe('The isString function', function() {
    it('returns true for strings', function() {
      return expect(isString('My Name is Cthulu!')).toEqual(true);
    });
    return it('returns false for numbers', function() {
      return expect(isString(5.4)).toEqual(false);
    });
  });

  describe('The sentence capitalization method', function() {
    return it('properly capitalizes a sentence', function() {
      var better;
      better = 'i walked my dog.'.toSentenceCase();
      return expect(better).toEqual('I walked my dog.');
    });
  });

  describe('The product method', function() {
    it('computes the product of an array of numbers', function() {
      var product, testArray;
      testArray = [1, 2, 3, 4];
      product = testArray.prod();
      return expect(product).toEqual(24);
    });
    return it('even works on heterogeneous arrays', function() {
      var testArray;
      testArray = [1, 'two', 3, 'four'];
      return expect(testArray.prod()).toEqual(3);
    });
  });

  describe('The sum method', function() {
    it('computes the sum of the numbers in an array', function() {
      var testArray;
      testArray = [1, 2, 3, 4];
      return expect(testArray.sum()).toEqual(10);
    });
    return it('even works on heterogenous arrays', function() {
      var testArray;
      testArray = [1, 'two', 3, 'four'];
      return expect(testArray.sum()).toEqual(4);
    });
  });

  describe('The empty method', function() {
    it('returns true is an array is empty', function() {
      var testArray;
      testArray = [];
      return expect(testArray.isEmpty()).toEqual(true);
    });
    return it('returns false when the array is populated', function() {
      var testArray;
      testArray = ['string content'];
      return expect(testArray.isEmpty()).toEqual(false);
    });
  });

  describe('The normalize method', function() {
    return it('normalizes an array array of numbers so they sum to unity', function() {
      var testArray;
      testArray = [80, 10, 10];
      return expect(testArray.normalize()).toEqual([.8, 0.1, 0.1]);
    });
  });

  describe('The zeros utility', function() {
    return it('returns an array containing the requested number of zeros', function() {
      return expect(zeros(5)).toEqual([0, 0, 0, 0, 0]);
    });
  });

  describe('The ones utility', function() {
    return it('returns an array containing the requested number of zeros', function() {
      return expect(ones(5)).toEqual([1, 1, 1, 1, 1]);
    });
  });

  describe('The remove utility', function() {
    return it('removes the specified element from an array', function() {
      var myArray, obj1, obj2, obj3;
      obj1 = {
        id: 1
      };
      obj2 = {
        id: 2
      };
      obj3 = {
        id: 3
      };
      myArray = [obj1, obj2, obj3];
      myArray.remove(obj2);
      return expect(myArray).toEqual([obj1, obj3]);
    });
  });

  describe('The string trim function', function() {
    it('trims leading spaces', function() {
      return expect('   Leading space'.trim()).toEqual('Leading space');
    });
    it('trims trailing spaces', function() {
      return expect('Trailing space   '.trim()).toEqual('Trailing space');
    });
    return it('trims both leading and trailing space', function() {
      return expect('   trailing & leading space   '.trim()).toEqual('trailing & leading space');
    });
  });

  describe('The intersection utility', function() {
    it('returns the common elements of two arrays', function() {
      var x, y;
      x = ['milk', 'eggs', 'coffee'];
      y = ['coffee', 'blood diamonds', 'milk'];
      return expect(intersect(x, y)).toEqual(['milk', 'coffee']);
    });
    return it('returns an empty set if there is no intersection', function() {
      var x, y;
      x = [1, 2, 3];
      y = [4, 5, 6];
      return expect(intersect(x, y)).toEqual([]);
    });
  });

  describe('The contains array method', function() {
    it('returns a boolean indicating whether it contains specified element', function() {
      var x;
      x = ['milk', 'eggs', 'coffee'];
      return expect(x.contains('eggs')).toEqual(true);
    });
    return it('returns false if the array does not contain that object', function() {
      var x;
      x = ['milk', 'eggs', 'coffee'];
      return expect(x.contains('blood diamonds')).toEqual(false);
    });
  });

  describe('The discrete sampling function', function() {
    return it('draws from');
  });

}).call(this);
