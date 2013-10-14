angular.module('tsp-demo')
  .directive 'canvas', ($parse, $window) ->
    restrict: 'E'
    link: (scope, elem, attrs) ->
      initFn = $parse attrs.initFrame
      animFn = $parse attrs.animFrame
      locals =
        $context: elem[0].getContext '2d'
      
      animate = (time) ->
        locals.time = time
        
        $window.requestAnimationFrame animate
        scope.$apply () ->
          animFn scope, locals
      
      initFn scope, locals
      $window.requestAnimationFrame animate    
  