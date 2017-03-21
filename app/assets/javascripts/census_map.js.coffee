class CensusMap
  constructor: (selector) ->
    @map = L.map(selector)

  search: (query) ->
    $('#js-verification-map-error').hide('slow')

    if @marker
      @map.removeLayer(@marker)

    baseUrl = 'https://nominatim.openstreetmap.org/search'
    url = "#{baseUrl}?q=#{query},Catalonia,Spain&format=json"
    map = this

    $.getJSON(url, (data) ->
      if(data[0])
        lat = data[0].lat
        lon = data[0].lon
        $('#verification_center_latitude').val(lat)
        $('#verification_center_longitude').val(lon)
        map.add_marker(lat, lon)
      else
        $('#js-verification-map-error').show('slow')
    )

  show: ->
    @map.setView([ 41.380256, 2.183807 ], 8)

    # map type
    tile_provider = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png'
    tile_attribution =
      '&copy; ' +
      '<a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'

    L.tileLayer(tile_provider, {
      maxZoom: 15,
      minZoom: 8,
      attribution: tile_attribution
    }).addTo(@map)

  add_marker: (lat, lng) ->
    @marker = L.circle([lat, lng], {
      color: 'transparent',
      fillColor: '#4d4d4d',
      fillOpacity: 0.5,
      radius: 5000
    })

    @marker.addTo(@map)

window.CensusMap = CensusMap
