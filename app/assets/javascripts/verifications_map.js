/* global L */

function get_coords(district) {
  if (!district) {
    return [ 41.380256, 2.183807 ];
  }

  switch (district) {
  case 0: // Sant Martí
    return [ 41.408131, 2.205780 ];
  case 1: // Ciutat Vella
    return [ 41.380256, 2.183807 ];
  case 2: // Eixample
    return [ 41.393738, 2.166360 ];
  case 3: // Sants-Montjuïc
    return [ 41.349833, 2.152386 ];
  case 4: // Les Corts
    return [ 41.385368, 2.120537 ];
  case 5: // Sarrià-Sant Gervasi
    return [ 41.401936, 2.136704 ];
  case 6: // Gràcia
    return [ 41.402203, 2.160836 ];
  case 7: // Horta-Guinardó
    return [ 41.426791, 2.155601 ];
  case 8: // Nou Barris
    return [ 41.445452, 2.179409 ];
  case 9: // Sant Andreu
    return [ 41.433091, 2.194042 ];
  default:
    return [ 41.380256, 2.183807 ];
  }
}

function verification_map_show(district) {

  var map = L.map('js-verification-map').setView(get_coords(district), 13);

  // map type
  // should support HTTPS
  // https://leaflet-extras.github.io/leaflet-providers/preview/
  // the pretty ones aren't secure - they either don't support https or are private services :( 
  var map_tile_provider = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  var map_tile_attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'; 
  L.tileLayer(map_tile_provider, {
    maxZoom: 15,
    minZoom: 11,
    attribution: map_tile_attribution
  }).addTo(map);

  // all your markers are belong to us
  $('.js-verification-map-centers li:not(.strike)').each( function(){
    var latlng = $(this).data('location');
    if ( latlng && latlng != ', ' ) {
      var lat = parseFloat( latlng.split(',')[0] );
      var lng = parseFloat( latlng.split(',')[1] );
      var name = $(this).find('.verification-center-name').html();
      var address = $(this).find('.verification-center-address').html();
      var slots = $(this).find('.verification-center-slots').html();
      var circle = L.circle([lat, lng], {
        color: 'transparent',
        fillColor: '#4d4d4d',
        fillOpacity: 0.5,
        radius: 500
      });
      circle.addTo(map).bindPopup(
        '<b>' + name + '</b><br />' + address + '<br />' + slots
      );
    }
  });

}

// show all the verifications centers for a given district
function verification_list_show(district){
  $('*[data-district="' + district + '"]').show();
}

function init_verification_map() {
  var district = $('.js-verification-map-centers').data('user-district'); 
  verification_map_show(district);
  verification_list_show(district);
}

$(function(){

  if ( $('#js-verification-map').length > 0 ){
    init_verification_map();
  }

  // show all the centers hidden
  $('.js-verification-map-centers-show').on('click', function(e){
    e.preventDefault();
    $(this).hide();
    $('.js-verification-map-centers li, .js-verification-map-centers p').show('slow').removeClass('hide');
  });

});
