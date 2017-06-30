<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Heatmaps</title>
<style>
/* Always set the map height explicitly to define the size of the div
       * element that contains the map. */

/* Optional: Makes the sample page fill the window. */
html, body {
	height: 100%;
	margin: 0;
	padding: 0;
}

#floating-panel {
	position: absolute;
	top: 10px;
	left: 25%;
	z-index: 5;
	background-color: #fff;
	padding: 5px;
	border: 1px solid #999;
	text-align: center;
	font-family: 'Roboto', 'sans-serif';
	line-height: 30px;
	padding-left: 10px;
}

#floating-panel {
	background-color: #fff;
	border: 1px solid #999;
	left: 25%;
	padding: 5px;
	position: absolute;
	top: 10px;
	z-index: 5;
}

* {
	box-sizing: border-box;
}

#map {
	height: 100%;
	border: 1px solid black;
}

#legend {
	position: relative;
	width: 100%;
	height: 30px;
	margin-top: 5px;
}

#legendGradient {
	width: 100%;
	height: 15px;
	border: 1px solid black;
}
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
</head>

<body>
	<div id="floating-panel">
		<button onclick="toggleHeatmap()">Toggle Heatmap</button>
		<button onclick="changeGradient()">Change gradient</button>
		<button onclick="changeRadius()">Change radius</button>
		<button onclick="changeOpacity()">Change opacity</button>
	</div>
	<div id="map"></div>
	<div id="legend">
		<div id="legendGradient"></div>
	</div>
	<script>
		// This example requires the Visualization library. Include the libraries=visualization
		// parameter when you first load the API. For example:
		// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=visualization">

		var map, heatmap, gradient;

		function initMap() {
			map = new google.maps.Map(document.getElementById('map'), {
				zoom : 4,
				center : {
					lat : 17.45081930,
					lng : 78.39
				},
				mapTypeId : 'hybrid'
			});
		}

		$.ajax({
			url : 'http://119.81.76.66:81/applocation/',
			type : "GET",
			cache : false,
			dataType : 'json',
			success : function(data) {

				console.log(data);

				heatmap = new google.maps.visualization.HeatmapLayer({
					data : getPoints(data),
					map : map
				});

				changeGradient();
				/* setLegendGradient();
				setLegendLabels(); */
			}
		});

		function toggleHeatmap() {
			heatmap.setMap(heatmap.getMap() ? null : map);
		}

		function changeGradient() {
			gradient = [ 'rgba(0, 255, 255, 0)', 'rgba(0, 255, 255, 1)',
					'rgba(0, 191, 255, 1)', 'rgba(0, 127, 255, 1)',
					'rgba(0, 63, 255, 1)', 'rgba(0, 0, 255, 1)',
					'rgba(0, 0, 223, 1)', 'rgba(0, 0, 191, 1)',
					'rgba(0, 0, 159, 1)', 'rgba(0, 0, 127, 1)',
					'rgba(63, 0, 91, 1)', 'rgba(127, 0, 63, 1)',
					'rgba(191, 0, 31, 1)', 'rgba(255, 0, 0, 1)' ]
			heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
		}

		function changeRadius() {
			heatmap.set('radius', heatmap.get('radius') ? null : 20);
		}

		function changeOpacity() {
			heatmap.set('opacity', heatmap.get('opacity') ? null : 0.2);
		}

		// Heatmap data: 500 Points
		function getPoints(data) {
			var locations = [];
			for (var i = 0; i < data.length; i++) {
				locations.push(new google.maps.LatLng(data[i].locations[0].lat,
						data[i].locations[0].lng));
			}
			return locations;
		}

		function setLegendGradient() {
			var gradientCss = '(left';
			for (var i = 0; i < gradient.length; ++i) {
				gradientCss += ', ' + gradient[i];
			}
			gradientCss += ')';

			$('#legendGradient').css('background',
					'-webkit-linear-gradient' + gradientCss);
			$('#legendGradient').css('background',
					'-moz-linear-gradient' + gradientCss);
			$('#legendGradient').css('background',
					'-o-linear-gradient' + gradientCss);
			$('#legendGradient').css('background',
					'linear-gradient' + gradientCss);
		}

		function setLegendLabels() {
			google.maps.event
					.addListenerOnce(
							map,
							'tilesloaded',
							function() {
								var maxIntensity = heatmap['gm_bindings_']['data'][158]['kd']['D'];
								var legendWidth = $('#legendGradient')
										.outerWidth();

								for (var i = 0; i <= maxIntensity; ++i) {
									var offset = i * legendWidth / maxIntensity;
									if (i > 0 && i < maxIntensity) {
										offset -= 0.5;
									} else if (i == maxIntensity) {
										offset -= 1;
									}

									$('#legend').append($('<div>').css({
										'position' : 'absolute',
										'left' : offset + 'px',
										'top' : '15px',
										'width' : '1px',
										'height' : '3px',
										'background' : 'black'
									}));
									$('#legend').append($('<div>').css({
										'position' : 'absolute',
										'left' : (offset - 5) + 'px',
										'top' : '18px',
										'width' : '10px',
										'text-align' : 'center',
										'font-size' : '0.8em',
									}).html(i));
								}
							});
		}
	</script>
	<script async defer
		src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA_7P37S40gdWmkOfwFJGTJxzQPRVMCqUg&libraries=visualization&callback=initMap">
		
	</script>
</body>
</html>