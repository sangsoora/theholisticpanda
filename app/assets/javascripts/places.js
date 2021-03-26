function initMap(lat, lng, element, visible) {
  var myCoords = new google.maps.LatLng(lat, lng);
  var mapOptions = {
    center: myCoords,
    zoom: 12
  };
  var map = new google.maps.Map(document.getElementById(element), mapOptions);
  var marker = new google.maps.Marker({
      position: myCoords,
      map: map
  });
  if (visible != 'Public') {
    marker.setVisible(false);
    var circle = new google.maps.Circle({
      map: map,
      radius: 5000,
      fillColor: '#e57850',
      strokeColor: "#366735",
      strokeOpacity: 1,
      strokeWeight: 1
    });
    circle.bindTo('center', marker, 'position');
  }
}
