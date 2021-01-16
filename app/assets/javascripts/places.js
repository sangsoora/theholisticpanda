function initMap(lat, lng, element) {
  var myCoords = new google.maps.LatLng(lat, lng);
  var mapOptions = {
    center: myCoords,
    zoom: 15
  };
  var map = new google.maps.Map(document.getElementById(element), mapOptions);
  var marker = new google.maps.Marker({
      position: myCoords,
      map: map
  });
}
