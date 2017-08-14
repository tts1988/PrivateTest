var lastPos, lastAddr;

function initInfoWindow() {
  if(infoWindow) { infoWindow.close(); }
  else infoWindow = new google.maps.InfoWindow({map: map});

  return infoWindow;
}

function locateMap(pos) {
    map.setCenter(pos);
    initInfoWindow();

    locateMapOnClick(pos);
}

function locateMapOnClick(pos) {
    initInfoWindow();
    geocodeLatLng(geocoder, map, infoWindow, pos);

    var request = {
        location: pos,
        radius: '500',
        types: ['point_of_interest']
    };
    service.nearbySearch(request, callback);
}

function geocodeLatLng(geocoder, map, infoWindow, latlng) {
  geocoder.geocode({'location': latlng}, function(results, status) {
    if (status === 'OK') {
      if (results[0]) {
        centerPos(results[0].geometry.location, results[0].formatted_address);
      } else {
      }
    } else {
    }
  });
}

function callback(results, status) {
    clearItem();
    if (status === google.maps.places.PlacesServiceStatus.OK) {
        for (var i = 0; i < results.length; i++) {
            //createMarker(results[i]);
            idxLoc[i] = results[i];
            addItem( idxLoc[i] , i);
        }
    }
}

var centerPos = function(pos , addr) {
    lastPos = pos;
    lastAddr = addr;
    if(!marker) {
        marker = new google.maps.Marker({
          position: pos,
          icon: 'location_marker.png',
          map: map
        });
    }
    else {
        marker.setPosition( pos );
    }
    infoWindow.setContent(addr);
    infoWindow.open(map, marker);
}

var centerPos2 = function(pos , addr) {
    lastPos = pos;
    lastAddr = addr;
    if(!marker) {
        marker = new google.maps.Marker({
          position: pos,
          icon: 'location_marker.png',
          map: map
        });
    }
    else {
        marker.setPosition( pos );
    }
}

function locationError(error, infoWindow, pos) {
	  initInfoWindow();
    infoWindow.setPosition(pos);
    switch(error.code){
        case 0:
          console.log("获取位置信息出错！");
          infoWindow.setContent("获取位置信息出错！");
          break;
        case 1:
          console.log("您设置了阻止该页面获取位置信息！");
          infoWindow.setContent("您设置了阻止该页面获取位置信息！");
          break;
        case 2:
          console.log("浏览器无法确定您的位置！");
          infoWindow.setContent("浏览器无法确定您的位置！");
          break;
        case 3:
          console.log("获取位置信息超时！");
          infoWindow.setContent("获取位置信息超时！");
          break;
    }
}

function createMarker(place) {
    var placeLoc = place.geometry.location;
    var marker = new google.maps.Marker({
        map: map,
        icon: 'location_marker.png',
        position: place.geometry.location
    });

    google.maps.event.addListener(marker, 'click', function() {
        initInfoWindow();
        infoWindow.setContent(place.name);
        infoWindow.open(map, this);
        map.panTo(placeLoc);
    });
}

function searchTxt(txt) {
    var request = {
        location: lastPos,
        radius: 500,
        query: txt
    };

    service.textSearch(request, callback);
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

var getLatLng = function(callback) {
    var res = {lat: 39.903333, lng: 116.391667};
    var lat = parseFloat(getParameterByName('lat'));
    var lon = parseFloat(getParameterByName('lon'));
      if(lat && lon) {
          res = { lat: lat, lng: lon };
          if(callback)  callback(res);
      }
      else{
        // Try HTML5 geolocation.
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                res = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };
                if(callback)  callback(res);
            }, function(error) {
                locationError(error, infoWindow, map.getCenter());
            }, {timeout:30000});
        } else {
          locationError(error, infoWindow, map.getCenter());
        }
  }


  return res;
}

function degrees_to_radians(degrees)
{
  var pi = Math.PI;
  return degrees * (pi/180);
}

function distance(lat_a, lng_a, lat_b, lng_b)
{
    var earthRadius = 6371.393;
    var latDiff = degrees_to_radians(lat_b-lat_a);
    var lngDiff = degrees_to_radians(lng_b-lng_a);
    var a = Math.sin(latDiff /2) * Math.sin(latDiff /2) +
    Math.cos(degrees_to_radians(lat_a)) * Math.cos(degrees_to_radians(lat_b)) *
    Math.sin(lngDiff /2) * Math.sin(lngDiff /2);
    var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    var distance = earthRadius * c;

    return distance;
}

function getMobileOperatingSystem() {
  var userAgent = navigator.userAgent || navigator.vendor || window.opera;

      // Windows Phone must come first because its UA also contains "Android"
    if (/windows phone/i.test(userAgent)) {
        return "Windows Phone";
    }

    if (/android/i.test(userAgent)) {
        return "Android";
    }

    // iOS detection from: http://stackoverflow.com/a/9039885/177710
    if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
        return "iOS";
    }

    return "unknown";
}

function isSystemMobile() {
	var os = getMobileOperatingSystem();
	return os != "unknown";
}
