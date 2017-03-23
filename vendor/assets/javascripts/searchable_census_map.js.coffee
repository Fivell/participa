#= require census_map
#= require form_center_marker
#= require center_marker

class SearchableCensusMap extends CensusMap
  constructor: (selector, markerSelector) ->
    super(selector)

    if ($("form##{markerSelector}").length > 0)
      @verification_center = new FormCenterMarker($("form##{markerSelector}"))
    else
      @verification_center = new CenterMarker($("##{markerSelector}"))

  setResultMarker: ->
    @result_marker = this.addMarker(@verification_center)

  unsetResultMarker: ->
    @map.removeLayer(@result_marker)

  searchAddress: (street, postalcode, city) ->
    $('#js-verification-map-error').hide('slow')

    this.unsetResultMarker()

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

        map.setResultMarker()
      else
        $('#js-verification-map-error').show('slow')
    )

window.SearchableCensusMap = SearchableCensusMap
