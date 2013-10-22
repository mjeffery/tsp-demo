class @PriorityQueue
	constructor: (@comparator = (a,b) ->  a - b ) ->
		@elements = []

	insert: (elem) ->
		size = @elements.push elem
		current = size - 1

		while current > 0
			parent = Math.floor (current - 1) / 2

			break if @compare(current, parent) < 0

			@swap parent, current
			current = parent
		
		return size

	next: ->
		first = @elements[0]
		last = @elements.pop()
		size = @size()

		return first if size is 0

		@elements[0] = last 
		current = 0
		while current < size
			largest = current
			left = (2 * current) + 1
			right = (2 * current) + 2

			largest = left if left < size and @compare(left, largest) > 0
			largest = right if right < size and @compare(right, largest) > 0

			break if current is largest

			@swap largest, current
			current = largest

		return first

	size: -> @elements.length

	isEmpty: -> @size() is 0

	compare: (a, b) -> @comparator @elements[a], @elements[b]

	swap: (a, b) -> 
		temp = @elements[b]
		@elements[b] = @elements[a]
		@elements[a] = temp
		return