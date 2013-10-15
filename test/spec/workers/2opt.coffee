describe '2-Opt Library:', () ->
  describe 'calculates distance between nodes', () ->
    it 'can calculate distance between two nodes in the path', () ->
      expect(dist [{ x: 0, y: 0}, { x: 0, y: 10}], 0, 1).toEqual 10
    
    it 'can calculate the cost of an empty path', () ->
      expect(calculateCost []).toEqual 0
      
    it 'can calculate the cost of a path with 1 node', () ->
      expect(calculateCost [{x: 0, y: 0}]).toEqual 0
    
    it 'can calculate the cost of a path with 2 nodes', () ->
      path = [{ x: 0, y: 0}, { x: 0, y: 10}]
      expect(calculateCost path).toEqual 20
    
    it 'can calculate the cost of a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ]  
      expect(calculateCost path).toEqual 40
  
  describe 'simulates a 2-Opt swap...', () ->
    
    beforeEach () -> 
      @addMatchers
        toBeAlmostEqual: (expected, epsilon=0.001) ->
          Math.abs(@actual - expected) <= epsilon
        
    it 'on an empty path', () ->
      expect(try2optSwap [], 0, 0).toEqual 0
      
    it 'on a path with 1 node', () ->
      expect(try2optSwap [{x:0, y:0, cost:0}], 0, 0).toEqual 0
      
    it 'on a path with 2 nodes', () ->
      path = [{x: 0, y:10 }, {x:0, y:0}]
      calculateCost path
      expect(try2optSwap path, 0, 1).toEqual 0
      
    it 'on a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      cost = calculateCost path
      expect(try2optSwap path, 1, 2).toBeAlmostEqual 40 - cost
    
    it 'between distant nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x: 0, y:10 },
        {x:20, y: 0 },
        {x:30, y: 0 },
        {x:30, y:10 },
        {x:20, y:10 },
        {x:10, y:10 },
        {x:10, y: 0 }
      ]
      cost = calculateCost path
      expect(try2optSwap path, 2, 6).toBeAlmostEqual 80 - cost
    
    #it 'can simulate a 2-Opt swap using the first node in the path', () ->
   
    it 'on the same nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      cost = calculateCost path
      expect(try2optSwap path, 2, 2).toEqual 0
   
    it 'with "reversed" index arguments', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      cost = calculateCost path
      expect(try2optSwap path, 2, 1).toBeAlmostEqual 40 - cost