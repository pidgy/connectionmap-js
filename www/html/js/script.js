
document.addEventListener('DOMContentLoaded', function () {
  if (document.querySelectorAll('#map').length > 0)
  {
    if (document.querySelector('html').lang)
      lang = document.querySelector('html').lang;
    else
      lang = 'en';

    var js_file = document.createElement('script');
    js_file.type = 'text/javascript';
    js_file.src = 'https://maps.googleapis.com/maps/api/js?callback=initMap&key=ADD_YOUR_GOOGLE_MAPS_API_KEY_HERE&language=' + lang;
    document.getElementsByTagName('head')[0].appendChild(js_file);
  }
});

/* Set the width of the side navigation to 250px */
function openNav() {
    document.getElementById("mySidenav").style.width = "250px";
}

/* Set the width of the side navigation to 0 */
function closeNav() {
    document.getElementById("mySidenav").style.width = "0";
}

var map;
var inter = setInterval(plotTimer, 10000)

// Initialize Google Map
function initMap()
{
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 35, lng: 0},
    zoom: 3,
    styles:
[
    {
        "featureType": "all",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": 36
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 40
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "visibility": "on"
            },
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "all",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "administrative",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            },
            {
                "weight": 1.2
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 20
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 21
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 17
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 29
            },
            {
                "weight": 0.2
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 18
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 16
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000000"
            },
            {
                "lightness": 19
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [
            {
                "color": "#000101"
            },
            {
                "lightness": 1
            }
        ]
    }
]
  });
  map.setOptions({ minZoom: 3, maxZoom: 50 });
    
  plotTimer();
}

function plotTimer() {
    try {
        fetch('markers.json')
          .then(function(response){return response.json()})
          .then(plotMarkers);
    } catch (e) {
        console.log("markers.json is empty");
    }
}

var markers = [];
var polylines = [];
var homelat = "45.4215";
var homelon = "-75.6972";
var ipcolordict = {};
var publicip = "";
var publicgeo = "";

function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

function plotMarkers(m)
{
  document.getElementById('mySidenav').innerHTML = '';
  document.getElementById('mySidenav').innerHTML += '<a href="javascript:void(0)" class="closebtn" onclick="closeNav()">&times;</a>';
  document.getElementById('mySidenav').innerHTML += '<b></b>';
  document.getElementById('mySidenav').innerHTML += '<b>Active Connections </b>';
  var conndict = {}
  var home = new google.maps.LatLng(homelat, homelon);

  markers.push(
    new google.maps.Marker({
      position: home,
      map: map,
      icon: window.location.href + "/images/home.ico",
    })
  );

  m.forEach(function (marker) {
    var position = new google.maps.LatLng(marker.lat, marker.lng);

    markers.push(
      new google.maps.Marker({
        position: position,
        map: map,
        icon: window.location.href + "/images/server.ico",
        animation: google.maps.Animation.DROP,
        title: marker.src +" -> " + marker.ip + "\n city: " + marker.city + "\n country: " + marker.country_name + "\n code: " +marker.country_code + "\n zip: " + marker.zip_code
      })
    );
    if (!ipcolordict[marker.src])
    {
        ipcolordict[marker.src] = getRandomColor();
    }

    if (!conndict[marker.src])
    {
        conndict[marker.src] = []
    }
    conndict[marker.src].push(marker.ip + '\n' + marker.city + '\n' + marker.country_name + '\n')

    polylines.push(
      new google.maps.Polyline({ 
        path: [
            home,
            position
        ], 
        strokeColor: ipcolordict[marker.src], 
        strokeOpacity: 1.0, 
        strokeWeight: 1, 
        geodesic: true, 
        map: map
      })
    ); 
  });
   
  for (var key in conndict) {
    document.getElementById('mySidenav').innerHTML += '<font color='+ipcolordict[key]+'><p><strong>'+key+'</strong></b></font>';
    for (var i = 0; i < conndict[key].length; i++) {
        document.getElementById('mySidenav').innerHTML += '<i>' + conndict[key][i] + '</i>'; 
    }
  }
}
