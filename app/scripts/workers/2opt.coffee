@dist = (path, i, j) ->
  return 0 if i == j
  dx = path[i].x - path[j].x
  dy = path[i].y - path[j].y
  Math.sqrt dx * dx + dy * dy

# calculates the cost of each path segment and assigns it as a "cost" to the first node
# returns the sum of the costs
@calculateCost = (path) ->
  return 0 if path.length <= 1
  cost = path[path.length - 1].cost = dist(path, path.length-1, 0)
  cost += path[i-1].cost = dist(path, i-1, i) for i in [1..path.length - 1]
  return cost

@wrapIndex = (i, array) ->
  if i < 0
    array.length - (-i % array.length)
  else 
    i % array.length

# returns the change in cost
# precondition: calculateCost has been called on the path
@try2optSwap = (path, i, j) ->
  return 0 if path.length <= 3 or i == j or (i is 0 and j is path.length - 1)
  return try2optSwap path, j, i if j < i
  
  upper = wrapIndex j+1, path
  lower = wrapIndex i-1, path
  dist(path, i, upper, path) + dist(path, lower, j) - path[lower].cost - path[j].cost

@subarray = (array, i, j) ->
  array.slice(i, j-i)

@do2optSwap = (path, i, j) ->
  return do2optSwap j, i if j < i 
  newPath = path.slice(0, path.length)
  return newPath if i == j
  for ind in [0..j-i]
    newPath[i+ind] = path[j-ind];
  return newPath
