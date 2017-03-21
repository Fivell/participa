#= require census_map

$ ->
  if ( $('#js-verification-map').length > 0 )
    map = new CensusMap('js-verification-map')

    postalcode = $('.js-verification-map-centers').data('user-postalcode')
    map.show(postalcode)
    $('*[data-postalcode="' + postalcode + '"]').show()

    map.add_verification_centers('.js-verification-map-centers li')

    # show all the centers hidden
    $('.js-verification-map-centers-show').on('click', (e) ->
      e.preventDefault()
      $(this).hide()

      centersSelector =
        '.js-verification-map-centers li, .js-verification-map-centers p'

      $(centersSelector).show('slow').removeClass('hide')
    )
