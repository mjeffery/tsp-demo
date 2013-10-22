@wrapIndex = (i, len) -> if i < 0 then len - (-i % len) else i % len

class @TSPSolver
  constructor: (@nodes = []) -> 
    @path = (i for i in [0..@nodes.length - 1] by 1)
    @costs = (0 for i in [1..@nodes.length] by 1)
    @calculateCosts()

  calculateCosts: () ->
    @totalCost = 0
    return unless @path.length
    for i in [0..@path.length - 1]
      j = (i+1) % @path.length
      @totalCost += (@costs[i] = @segmentCost i, j)
    return
   
  # i & j refer to @path indecies, not @nodes
  segmentCost: (i, j) ->
    node_i = @nodes[@path[i]]
    node_j = @nodes[@path[j]]
    dx = node_i.x - node_j.x
    dy = node_i.y - node_j.y
    Math.sqrt dx * dx + dy * dy

  # i & j refer to @path indices, not @nodes
  try2optSwap: (i, j) ->
    return 0 if @path.length <= 3 or i is j or (i is 0 and j is @path.length - 1)
    return @try2optSwap j, i if j < i
    size = @path.length
    upper = wrapIndex j+1, size
    lower = wrapIndex i-1, size
    @segmentCost(i, upper) + @segmentCost(lower, j) - @costs[lower] - @costs[j  ]

  # i & j refer to @path indices, not @nodes
  do2optSwap: (i, j) ->
    return unless @path.length
    halfSize = Math.floor (j - i) / 2
    for k in [0..halfSize] by 1
      tmp = @path[i + k]
      @path[i + k] = @path[j - k]
      @path[j - k] = tmp
    return