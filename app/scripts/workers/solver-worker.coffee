importScripts 'scripts/2opt.js', 'scripts/PriorityQueue.js'

self.addEventListener 'message', (event) ->
	msg = event.data
	points = msg.points ? []
	path = [0..points.length]
	updateInterval = msg?.options ? 100
	showSteps = msg?.options ? false
	iterations = 0

