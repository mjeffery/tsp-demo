describe '2-Opt Library:', () ->
  
  beforeEach () -> 
      @addMatchers
        toAlmostEqual: (expected, epsilon=0.001) ->
          Math.abs(@actual - expected) <= epsilon
  
  describe 'Can calculate the cost of', () ->
    it 'an empty path', () ->
      tsp = new TSPSolver([])
      expect(tsp.totalCost).toEqual 0
      
    it 'a path with 1 node', () ->
      tsp = new TSPSolver([{x: 0, y: 0}])
      expect(tsp.totalCost).toEqual 0
    
    it 'a path with 2 nodes', () ->
      tsp = new TSPSolver([{ x: 0, y: 0}, { x: 0, y: 10}])
      expect(tsp.totalCost).toEqual 20
    
    it 'a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ]  
      tsp = new TSPSolver(path)
      expect(tsp.totalCost).toEqual 40
  
  describe 'wraps an index', () ->
    it 'when its negative', () ->
      expect(wrapIndex -1, 10).toEqual 9
    it 'when its longer than the array', () ->
      expect(wrapIndex 15, 10).toEqual 5
    it 'except when its in range', () ->
      expect(wrapIndex 3, 10).toEqual 3
  
  describe 'simulates a 2-Opt swap...', () ->        
    it 'on an empty path', () ->
      tsp = new TSPSolver([])
      expect(tsp.try2optSwap 0, 0).toEqual 0
      
    it 'on a path with 1 node', () ->
      tsp = new TSPSolver({x: 0, y: 0}) 
      expect(tsp.try2optSwap 0, 0).toEqual 0
      
    it 'on a path with 2 nodes', () ->
      path = [{x: 0, y:10 }, {x:0, y:0}]
      tsp = new TSPSolver(path)
      expect(tsp.try2optSwap 0, 1).toEqual 0

    it 'on a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      tsp = new TSPSolver(path)
      cost = tsp.totalCost
      expect(tsp.try2optSwap 1, 2).toAlmostEqual 40 - cost
    
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
      tsp = new TSPSolver(path)
      cost = tsp.totalCost
      expect(tsp.try2optSwap 2, 6).toAlmostEqual 80 - cost
    
    it 'using the first node in the path', () ->
      path = [
        {x: 0, y:10 },
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 }
      ]
      tsp = new TSPSolver(path)
      cost = tsp.totalCost
      expect(tsp.try2optSwap 0, 1).toAlmostEqual 40 - cost
      
    it 'using the last node in the path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x: 0, y:10 },
        {x:10, y:10 }
      ]
      tsp = new TSPSolver(path)
      cost = tsp.totalCost
      expect(tsp.try2optSwap 2, 3).toAlmostEqual 40 - cost
      
    it 'using the entire path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ]
      tsp = new TSPSolver(path)
      expect(tsp.try2optSwap 0, 3).toEqual 0   
   
    it 'on the same nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      tsp = new TSPSolver(path)
      expect(tsp.try2optSwap 2, 2).toEqual 0
      
    it 'with "reversed" index arguments', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ] 
      tsp = new TSPSolver(path)
      cost = tsp.totalCost
      expect(tsp.try2optSwap 2, 1).toAlmostEqual 40 - cost
      
  describe 'do a 2-Opt swap...', () ->
    it 'on an empty path', () ->  
      tsp = new TSPSolver([])
      tsp.do2optSwap 0, 0
      expect(tsp.path).toEqual []
      
    it 'on a path with 1 node', () ->
      tsp = new TSPSolver([{x: 0, y: 0}])
      tsp.do2optSwap 0, 0
      expect(tsp.path).toEqual [0]
          
    it 'on a path with 2 nodes', () ->
      tsp = new TSPSolver([{x:0, y:0}, {x:10, y:10}])
      tsp.do2optSwap 0, 1
      expect(tsp.path).toEqual [1, 0]
      
    it 'on a path with 3 or more nodes', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 },
        {x: 0, y:10 }
      ]
      tsp = new TSPSolver(path)
      tsp.do2optSwap 1, 2
      expect(tsp.path).toEqual [0, 2, 1, 3]
    
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
      tsp = new TSPSolver(path)
      tsp.do2optSwap 2, 6
      expect(tsp.path).toEqual [0, 1, 6, 5, 4, 3, 2, 7]
      
    it 'using the first node', () ->
      path = [
        {x: 0, y:10 },
        {x: 0, y: 0 },
        {x:10, y:10 },
        {x:10, y: 0 }
      ]
      tsp = new TSPSolver(path)
      tsp.do2optSwap 0, 1
      expect(tsp.path).toEqual [1, 0, 2, 3]

    it 'using the last node', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x: 0, y:10 },
        {x:10, y:10 }
      ]
      tsp = new TSPSolver(path)
      tsp.do2optSwap 2, 3
      expect(tsp.path).toEqual [0, 1, 3, 2]

    it 'using the entire path', () ->
      path = [
        {x: 0, y: 0 },
        {x:10, y: 0 },
        {x:10, y:10 },
        {x: 0, y:10 }
      ] 
      tsp = new TSPSolver(path)
      tsp.do2optSwap 0, 3
      expect(tsp.path).toEqual [3..0]
