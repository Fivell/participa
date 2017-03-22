#= require searchable_census_map

$ ->
  if ( $('#js-verification-map').length > 0 )
    map = new SearchableCensusMap('js-verification-map', 'verification_center')
    map.show()
    map.setResultMarker()

  $("#js-verification-map-search").on 'click', (event) ->
    event.preventDefault()
    street = $('#verification_center_street').val()
    postalcode = $('#verification_center_postalcode').val()
    city = $('#verification_center_city').val()
    map.searchAddress street, postalcode, city
