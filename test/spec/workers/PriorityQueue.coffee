describe 'PriorityQueue', () ->
	it 'can determine when its empty', () ->
		q = new PriorityQueue()
		expect(q.isEmpty()).toEqual true
	it 'can deque elements', () ->
		q = new PriorityQueue()
		q.insert(x) for x in [10, 5, 15, 0]
		expect(q.next()).toEqual(x) for x in [15, 10, 5, 0]
		expect(q.isEmpty()).toEqual true