#= require center_marker

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

  setView: (postalcode) ->
    if (!postalcode)
      @map.setView([this.coords().center.lat, this.coords().center.lon], 8)
      return

    censusMap = this

    this.search({ postalcode: postalcode }, (data) ->
      if data[0]
        center = { lat: data[0].lat, lon: data[0].lon }
        sw = { lat: data[0].boundingbox[0], lon: data[0].boundingbox[2] }
        ne = { lat: data[0].boundingbox[1], lon: data[0].boundingbox[3] }
      else
        center = censusMap.coords().center
        sw = censusMap.coords().sw
        ne = censusMap.coords().ne

      censusMap.map.setView([center.lat, center.lon], 8)
      censusMap.map.fitBounds(
        L.latLngBounds(L.latLng(sw.lat, sw.lon), L.latLng(ne.lat, ne.lon))
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

  addMarker: (centerMarker) ->
    marker = L.circle([centerMarker.lat(), centerMarker.lng()], {
      color: 'transparent',
      fillColor: '#4d4d4d',
      fillOpacity: 0.5,
      radius: 5000
    })

    marker.addTo(@map)

    name = centerMarker.name()
    address = centerMarker.address()

    label ='<b>' + name + '</b><br />' + address

    if centerMarker.slots()
      label = label + '<br />' + centerMarker.slots()

    marker.bindPopup(label)

    marker.on 'mouseover', -> @openPopup()
    marker.on 'mouseout', -> @closePopup()

    map = @map

    @map.on 'zoomend', ->
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
      marker.setRadius zoom2radius[currentZoom]

    marker

  addVerificationCenters: (selector) ->
    censusMap = this

    $(selector).each ->
      centerMarker = new CenterMarker($(this))

      censusMap.addMarker(centerMarker)

window.CensusMap = CensusMap
