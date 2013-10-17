describe '2-Opt Library:', () ->
  
  beforeEach () -> 
      @addMatchers
        toAlmostEqual: (expected, epsilon=0.001) ->
          Math.abs(@actual - expected) <= epsilon
  
  describe 'calculates distance between nodes', () ->
    it 'can calculate cost of...', () ->
      expect(dist [{ x: 0, y: 0}, { x: 0, y: 10}], 0, 1).toEqual 10
    
    it 'an empty path', () ->
      expect(calculateCost []).toEqual 0
      
    it 'a path with 1 node', () ->
      expect(calculateCost [{x: 0, y: 0}]).toEqual 0
    
    it 'a path with 2 nodes', () ->
      path = [{ x: 0, y: 0}, { x: 0, y: 10}]
      expect(calculateCost path).toEqual 20
    
    it 'a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ]  
      expect(calculateCost path).toEqual 40
  
  describe 'wraps an index...', () ->
    it 'when its negative', () ->
      expect(wrapIndex -1, [1..10]).toEqual 9
    it 'when its longer than the array', () ->
      expect(wrapIndex 15, [1..10]).toEqual 5
    it 'except when its in range', () ->
      expect(wrapIndex 3, [1..10]).toEqual 3
  
  describe 'simulates a 2-Opt swap...', () ->        
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
      expect(try2optSwap path, 1, 2).toAlmostEqual 40 - cost
    
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
      expect(try2optSwap path, 2, 6).toAlmostEqual 80 - cost
    
    it 'using the first node in the path', () ->
      path = [
        {x: 0, y:10 },
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 }
      ]
      cost = calculateCost path
      expect(try2optSwap path, 0, 1).toAlmostEqual 40 - cost
      
    it 'using the last node in the path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x: 0, y:10 },
        {x:10, y:10 }
      ]
      cost = calculateCost path
      expect(try2optSwap path, 2, 3).toAlmostEqual 40 - cost
      
    it 'using the entire path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ] 
      cost = calculateCost path
      expect(try2optSwap path, 0, 3).toEqual 0   
   
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
      expect(try2optSwap path, 2, 1).toAlmostEqual 40 - cost
      
  describe 'do a 2-Opt swap...', () ->
    expected4 = [
      {x: 0, y: 0 },
      {x:10, y: 0 },
      {x:10, y:10 },
      {x: 0, y:10 }
    ]
    expected8 = [
        {x: 0, y: 0 },
        {x: 0, y:10 },
        {x:10, y:10 },
        {x:20, y:10 },
        {x:30, y:10 },
        {x:30, y: 0 },
        {x:20, y: 0 },
        {x:10, y: 0}
      ]
    
    it 'on an empty path', () ->  
      expect(do2optSwap [], 0, 0).toEqual []
      
    it 'on a path with 1 node', () ->
      expect(do2optSwap [{x: 0, y: 0}], 0, 0).toEqual [{x: 0, y: 0}] 
          
    it 'on a path with 2 nodes', () ->
      expect(do2optSwap [{x:0, y:0}, {x:10, y:10}], 0, 1).toEqual [{x:10, y:10}, {x:0, y:0}]
      
    it 'on a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ]
      expect(do2optSwap path, 1, 2).toEqual expected4
    
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
      expect(do2optSwap path, 2, 6).toEqual expected8
      
    it 'using the first node', () ->
      path = [
        {x: 0, y:10 },
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 }
      ]
      expect(do2optSwap path, 0, 1).toEqual expected4
      
    it 'using the last node', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x: 0, y:10 },
        {x:10, y:10 }
      ]
      expect(do2optSwap path, 2, 3).toEqual expected4
      
    it 'using the entire path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ] 
      expect(do2optSwap path, 0, 3).toEqual expected4
      
    
      
