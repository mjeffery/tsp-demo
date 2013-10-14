angular.module('tsp-demo')
  .controller 'tspController', ($scope, Node) ->
    nodes = []
    lastTime = Date.now()
      
    $scope.draw = (ctx, time) ->
      dt = time - lastTime
      lastTime = time
      
      dt = 0 if dt < 0
      dt = 100 if dt > 100
      
      ctx.clearRect 0, 0, 800, 600
      
      angular.forEach nodes, (node) ->
        node.update dt
        node.draw ctx
      
      if nodes.length > 1
        lastNode = nodes[nodes.length - 1]
        
        ctx.beginPath()
        ctx.moveTo lastNode.x, lastNode.y
        angular.forEach nodes, (node) -> ctx.lineTo node.x, node.y
        ctx.strokeStyle = 'black'
        ctx.stroke()
      
      nodes = nodes.filter (node) -> not node.isDestroyed()
      
    $scope.onClick = (x, y) ->
      for node in nodes.reverse()
        if node.contains x, y
          node.destroy()
          return
          
      nodes.push new Node x, y
