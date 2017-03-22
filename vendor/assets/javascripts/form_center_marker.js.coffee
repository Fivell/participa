class FormCenterMarker
  constructor: (selector) ->
    @selector = selector

  lat: ->
    @selector.find("input[id$='_latitude']").val()

  lng: ->
    @selector.find("input[id$='_longitude']").val()

  name: ->
    @selector.find("input[id$='_name']").val()

  address: ->
    street = @selector.find("input[id$='_street']").val()
    postalcode = @selector.find("input[id$='_postalcode']").val()
    city = @selector.find("input[id$='_city']").val()

    [street, postalcode, city].filter((val) -> val).join(', ')

  slots: ->
    ''

window.FormCenterMarker = FormCenterMarker
