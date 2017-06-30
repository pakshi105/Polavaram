<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0">
    <meta name="apple-mobile-web-app-capable" content="yes">
        <title>OpenLayers 2 Google (v3) Layer Example</title>
        <link rel="stylesheet" href="../theme/default/style.css" type="text/css">
        <link rel="stylesheet" href="style.css" type="text/css">
        <script src="http://maps.google.com/maps/api/js?key=AIzaSyDMztqxHe0RHZDrEpiPxL_fHsCUykaxmwk=3&amp;sensor=false"></script>
        <script src="js/OpenLayers.js"></script>
    </head>
    <body onload="init()">
        <h1 id="title">Google (v3) Layer Example</h1>
        <div id="tags">
            Google, api key, apikey, light
        </div>
        <p id="shortdesc">
            Demonstrate use the Google Maps v3 API.
        </p>
        <div id="map" class="smallmap"></div>
        <div id="docs">
            <p><input id="animate" type="checkbox" checked="checked">Animated
                zoom (if supported by GMaps on your device)</input></p>
            <p>
                Google is encouraging the use of keys for Google Maps APIs as
                described here: <a href="https://developers.google.com/maps/documentation/javascript/get-api-key">https://developers.google.com/maps/documentation/javascript/get-api-key</a>.
                Once you have included the Google Maps script in your html,
                refer to the
                <a href="google.js" target="_blank">google.js source</a>
                to see how to use Google Maps as layer in OpenLayers.
            </p>
        </div>
<script>
var map;

function init() {
    map = new OpenLayers.Map('map', {
        projection: 'EPSG:3857',
        layers: [
            new OpenLayers.Layer.Google(
                "Google Physical",
                {type: google.maps.MapTypeId.TERRAIN}
            ),
            new OpenLayers.Layer.Google(
                "Google Streets", // the default
                {numZoomLevels: 20}
            ),
            new OpenLayers.Layer.Google(
                "Google Hybrid",
                {type: google.maps.MapTypeId.HYBRID, numZoomLevels: 20}
            ),
            new OpenLayers.Layer.Google(
                "Google Satellite",
                {type: google.maps.MapTypeId.SATELLITE, numZoomLevels: 22}
            )
        ],
        center: new OpenLayers.LonLat(10.2, 48.9)
            // Google.v3 uses web mercator as projection, so we have to
            // transform our coordinates
            .transform('EPSG:4326', 'EPSG:3857'),
        zoom: 5
    });
    map.addControl(new OpenLayers.Control.LayerSwitcher());
    
    // add behavior to html
    var animate = document.getElementById("animate");
    animate.onclick = function() {
        for (var i=map.layers.length-1; i>=0; --i) {
            map.layers[i].animationEnabled = this.checked;
        }
    };
}
</script>
</body>
</html>