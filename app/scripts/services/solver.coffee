angular.module('tsp-demo')
  .factory 'Solver', () ->
    class Solver 
      constructor: () ->
        @worker = null
        @listeners = {}
        @options =
          algorithm: 'greedy 2-opt'
          updateInterval: 100
          showSteps: false

      solveAsync: (nodes) ->
        @worker.terminate if @worker?
        @worker = new Worker('scripts/solver-worker.js')
        for event, callbacks in @listeners
          @worker.addEventListener event, callback for callback in callbacks
        points = { x: node.x, y: node.y } for node in nodes
        @worker.pushMessage 'solve', {
          points
          @options
        }
        return

      cancel: ->
        if @worker?
          @worker.terminate
          @worker = null

      addEventListener: (event, callback) ->
        listeners = @listeners[event];
        if listeners?
          idx = listeners.indexOf callback
          listeners.splice idx, 1 if idx >= 0
          listeners.push callback 
        else
          listeners = [callback]
          @listeners[event] = listeners
        @worker.addEventListener event, callback if @worker?  
        return

      removeEventListener: (event, callback) ->
        listeners = @listeners[event];
        if listeners?
          idx = listeners.indexOf callback
          listeners.splice idx, 1 if idx >= 0
        @worker.removeEventListener event, callback if @worker? 
        return
