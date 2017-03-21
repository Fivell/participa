#= require census_map

$ ->
  if ( $('#js-verification-map').length > 0 )
    map = new CensusMap('js-verification-map')
    map.show()

  if (  $("#verification_center_latitude").length > 0 and
        $("#verification_center_latitude").val() != "" )
    lat = $('#verification_center_latitude').val()
    lon = $('#verification_center_longitude').val()
    map.set_temp_marker lat, lon

  if ( $('.js-verification-map-latitude td').length > 0 and
       $('.js-verification-map-latitude td').html() != "" )
    lat = $('.js-verification-map-latitude td').html()
    lon = $('.js-verification-map-longitude td').html()
    map.add_marker lat, lon

  $("#js-verification-map-search").on 'click', (event) ->
    event.preventDefault()
    q = $('#verification_center_address').val()
    map.search q
