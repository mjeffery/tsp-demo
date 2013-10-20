describe 'PriorityQueue', () ->
	it 'can insert an element', () ->
		q = new PriorityQueue
		q.insert 0
		expect(q.elements[0]).toEqual 0
