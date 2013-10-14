@dist = (path, i, j) ->
  dx = path[i].x - path[j].x
  dy = path[i].y - path[j].y
  Math.sqrt dx * dx + dy * dy

@calculateCost = (path) ->
  return 0 if path.length <= 1
  cost = path[path.length - 1].cost = dist(path, path.length-1, 0)
  cost += path[i-1].cost = dist(path, i-1, i) for i in [1..path.length - 1]
  return cost
  
@try2optSwap = (path, i, j) ->
  return 0 if path.length <= 3
  dist(path, i, j+1) + dist(path, i-1, j) - path[i-1].cost - path[j].cost

@do2optSwap = (path, i, j) ->
  path.slice(0, i-1).concat path.slice(i, j-1).reverse(), path.slice(j, path.length - 1)
