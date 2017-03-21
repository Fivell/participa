/* global L */

function verification_map_set_view(map, postalcode) {
  var catalonia = {
    center: {
      lat: 41.8523094,
      lon: 1.5745043
    },
    sw: {
      lat: 40.5230524,
      lon: 3.3323241
    },
    ne: {
      lat: 42.8615226,
      lon: 0.1591812
    }
  };

  if (!postalcode) {
    map.setView([catalonia.center.lat, catalonia.center.lon], 8);
    return map;
  }

  var viewbox = [
    catalonia.sw.lat, catalonia.ne.lat, catalonia.ne.lon, catalonia.sw.lon
  ].join(',');
  var bounded = '1';
  var format = 'json';

  var baseUrl = 'https://nominatim.openstreetmap.org/search';
  var urlParams = $.param({
    postalcode: postalcode,
    viewbox: viewbox,
    bounded: bounded,
    format: format
  });

  $.getJSON(baseUrl + '?' + urlParams, function (data) {
    var lat, lon, box;

    if (data[0]) {
      lat = data[0].lat;
      lon = data[0].lon;
      box = data[0].boundingbox;
    } else {
      lat = catalonia.center.lat;
      lon = catalonia.center.lon;
      box = viewbox;
    }

    map.setView([lat, lon], 8);
    map.fitBounds(
      L.latLngBounds(L.latLng(box[0], box[3]), L.latLng(box[1], box[2]))
    );
    return map;
  });
}

function verification_map_show(postalcode) {
  var map = L.map('js-verification-map');

  verification_map_set_view(map, postalcode);

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
  $('.js-verification-map-centers li').each( function(){
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
      circle.on('mouseover', function() { this.openPopup(); });
      circle.on('mouseout', function() { this.closePopup(); });
    }
  });

}

// show all the verifications centers for a given postalcode
function verification_list_show(postalcode){
  $('*[data-postalcode="' + postalcode + '"]').show();
}

function init_verification_map() {
  var postalcode = $('.js-verification-map-centers').data('user-postalcode');
  verification_map_show(postalcode);
  verification_list_show(postalcode);
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
