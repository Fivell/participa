class CensusMap
  constructor: (selector) ->
    @map = L.map(selector)

  coords: ->
    {
      center: {
        lat: 41.8523094,
        lon: 1.5745043
      },
      sw: {
        lat: 40.5230524,
        lon: 0.1591812
      },
      ne: {
        lat: 42.8615226,
        lon: 3.3323241
      }
    }

  search: (params, handler) ->
    viewbox = [
      this.coords().sw.lon,
      this.coords().ne.lat,
      this.coords().ne.lon,
      this.coords().sw.lat
    ].join(',')

    bounded = '1'
    format = 'json'

    baseUrl = 'https://nominatim.openstreetmap.org/search'

    defaultParams =
      viewbox: viewbox
      bounded: bounded
      format: format

    urlParams = $.param($.extend(defaultParams, params))

    $.getJSON(baseUrl + '?' + urlParams, handler)

  searchAddress: (street, postalcode, city) ->
    $('#js-verification-map-error').hide('slow')

    this.unsetTempMarker()

    params = { street: street, city: city }
    if postalcode.trim() != ''
      $.extend(params, { postalcode: postalcode })

    map = this

    this.search(params, (data) ->
      if(data[0])
        lat = data[0].lat
        lon = data[0].lon
        $('#verification_center_latitude').val(lat)
        $('#verification_center_longitude').val(lon)
        map.setTempMarker(lat, lon)
      else
        $('#js-verification-map-error').show('slow')
    )

  setView: (postalcode) ->
    if (!postalcode)
      @map.setView([this.coords().center.lat, this.coords().center.lon], 8)
      return

    map = @map

    this.search({ postalcode: postalcode }, (data) ->
      if data[0]
        lat = data[0].lat
        lon = data[0].lon
        box = data[0].boundingbox
      else
        lat = map.coords().center.lat
        lon = map.coords().center.lon
        box = viewbox

      map.setView([lat, lon], 8)
      map.fitBounds(
        L.latLngBounds(L.latLng(box[0], box[3]), L.latLng(box[1], box[2]))
      )
    )

  show: (postalcode) ->
    this.setView(postalcode)

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

  setTempMarker: (lat, lng) ->
    @marker = this.addMarker(lat, lng)

  unsetTempMarker: ->
    if @marker
      @map.removeLayer(@marker)
      @marker = undefined

  addMarker: (lat, lng) ->
    marker = L.circle([lat, lng], {
      color: 'transparent',
      fillColor: '#4d4d4d',
      fillOpacity: 0.5,
      radius: 5000
    })

    marker.addTo(@map)

  addVerificationCenters: (selector) ->
    censusMap = this

    $(selector).each ->
      latlng = $(this).data('location')

      if latlng and latlng != ', '
        lat = parseFloat(latlng.split(',')[0])
        lng = parseFloat(latlng.split(',')[1])
        name = $(this).find('.verification-center-name').html()
        address = $(this).find('.verification-center-address').html()
        slots = $(this).find('.verification-center-slots').html()

        circle = censusMap.addMarker(lat, lng)

        popUp ='<b>' + name + '</b><br />' + address + '<br />' + slots
        circle.bindPopup(popUp)

        circle.on 'mouseover', ->
          @openPopup()
        circle.on 'mouseout', ->
          @closePopup()

        map = censusMap.map

        map.on 'zoomend', ->
          zoom2radius =
            8: 5000
            9: 3000
            10: 2000
            11: 1000
            12: 500
            13: 400
            14: 300
            15: 200
          currentZoom = map.getZoom()
          circle.setRadius zoom2radius[currentZoom]

window.CensusMap = CensusMap
