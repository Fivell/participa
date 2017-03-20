map_search_address = (query, map, marker) ->
  $('#js-verification-map-error').hide('slow')
  if marker
    map.removeLayer(marker)
  url = "https://nominatim.openstreetmap.org/search?q=#{query},Catalunya,Spain&format=json"
  $.getJSON(url, (data) ->
    if(data[0])
      lat = data[0].lat
      lon = data[0].lon
      $('#verification_center_latitude').val(lat)
      $('#verification_center_longitude').val(lon)
      map_add_marker lat, lon, map
    else
      $('#js-verification-map-error').show('slow')
      console.log("NO RESULTS")
  )

map_show = () ->
  map = L.map('js-verification-map').setView([ 41.380256, 2.183807 ], 12)
  # map type
  map_tile_provider = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
  map_tile_attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
  L.tileLayer(map_tile_provider, {
    maxZoom: 15,
    minZoom: 11,
    id: 'examples.map-i875mjb7',
    attribution: map_tile_attribution
  }).addTo(map)
  return map

map_add_marker = (lat, lng, map) ->
  circle = L.circle([lat, lng], {
    color: 'transparent',
    fillColor: '#4d4d4d',
    fillOpacity: 0.5,
    radius: 500
    })
  marker = circle.addTo(map)
  return marker

$ ->
  marker = false

  if ( $('#js-verification-map').length > 0 )
    map = map_show()

  if (  $("#verification_center_latitude").length > 0 and  $("#verification_center_latitude").val() != "" )
    lat = $('#verification_center_latitude').val()
    lon = $('#verification_center_longitude').val()
    marker = map_add_marker lat, lon, map

  if ( $('.js-verification-map-latitude td').length > 0 and $('.js-verification-map-latitude td').html() != "" )
    lat = $('.js-verification-map-latitude td').html()
    lon = $('.js-verification-map-longitude td').html()
    map_add_marker lat, lon, map

  $("#js-verification-map-search").on 'click', (event) ->
    event.preventDefault()
    q = $('#verification_center_address').val()
    map_search_address q, map, marker
