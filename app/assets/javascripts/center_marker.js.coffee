class CenterMarker
  constructor: (selector) ->
    @selector = selector

  lat: ->
    @selector.data('latitude')

  lng: ->
    @selector.data('longitude')

  name: ->
    @selector.data('name')

  address: ->
    @selector.data('address')

  slots: ->
    @selector.data('slots')

window.CenterMarker = CenterMarker
