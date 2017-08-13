var lastPos, lastAddr;
function locateMap(pos) {
	map.setCenter(pos);
    		
	infoWindow = new google.maps.InfoWindow({map: map});
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
	      icon: 'img/location_marker.png',
	      map: map
	    });
	}
	else {
		marker.setPosition( pos );
	}
    infoWindow.setContent(addr);
    infoWindow.open(map, marker);
}

function locationError(error, infoWindow, pos) {
	infoWindow = new google.maps.InfoWindow({map: map});
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
		icon: 'img/location_marker.png',
		position: place.geometry.location
	});

	google.maps.event.addListener(marker, 'click', function() {
		infoWindow.close();
		infoWindow = new google.maps.InfoWindow({map: map});
		infoWindow.setContent(place.name);
		infoWindow.open(map, this);
		map.panTo(placeLoc);
	});
}