<!DOCTYPE html>
<html>
<head>
    <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
<title>Annotorious - Image Annotation for the Web</title>
<style type="text/css">
v\:* {
	behavior: url(#default#VML);
}

html, body {
	overflow: hidden;
	padding: 0;
	height: 100%;
	width: 100%;
	font-family: 'Lucida Grande', Geneva, Arial, Verdana, sans-serif;
}

body {
	margin: 10px;
	background: #fff;
}

h1 {
	margin: 0;
	padding: 6px;
	border: 0;
	font-size: 20pt;
}

#header {
	height: 43px;
	padding: 0;
	background-color: #eee;
	border: 1px solid #888;
}

#subheader {
	height: 12px;
	text-align: right;
	font-size: 10px;
	color: #555;
}

#map {
	height: 95%;
	border: 1px solid #888;
}

.olImageLoadError {
	display: none;
}

.olControlLayerSwitcher .layersDiv {
	border-radius: 10px 0 0 10px;
}


</style>
<style>
.olControlLayerSwitcher .layersDiv{
	display:none !important;
}
.modal-dialog {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
}

.modal-content {
  width : auto;
  min-width: 100%;
  border-radius: 0;
}
</style>
<link type="text/css" rel="stylesheet" href="latest/annotorious.css" />
<link href="css/style.css" rel="stylesheet" type="text/css">
<!-- <link href="../css/bootstrap.min.css" rel="stylesheet" type="text/css"> -->
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<link href="latest/themes/dark/annotorious-dark.css" rel="stylesheet"
	type="text/css" />
<!-- <script type="text/javascript" src="../js/jquery-3.1.1.min.js"></script>
	<script type="text/javascript" src="../js/bootstrap.min.js"></script> -->
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	

<script
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA_7P37S40gdWmkOfwFJGTJxzQPRVMCqUg"></script>
<script src="http://www.openlayers.org/api/2.12/OpenLayers.js"></script>
<script>
              var map;
              var mapBounds = new OpenLayers.Bounds( 81.6346744526, 17.2871326665, 81.64194899, 17.293077497);
              var mapMinZoom = 15;
              var mapMaxZoom = 21;
              var emptyTileURL = "http://www.maptiler.org/img/none.png";
              OpenLayers.IMAGE_RELOAD_ATTEMPTS = 3;
			 
              function init(){
                  var options = {
                      div: "map",
                      controls: [],
                      projection: "EPSG:3857",
                      displayProjection: new OpenLayers.Projection("EPSG:4326"),
                      numZoomLevels: 20
                  };
                  map = new OpenLayers.Map(options);

                  // Create Google Mercator layers
                  var gmap = new OpenLayers.Layer.Google("Google Streets",
                  {
                      type: google.maps.MapTypeId.ROADMAP,
                      sphericalMercator: true
                  });
                  var gsat = new OpenLayers.Layer.Google("Google Satellite",
                  {
                      type: google.maps.MapTypeId.SATELLITE,
                      sphericalMercator: true
                  });
                  var ghyb = new OpenLayers.Layer.Google("Google Hybrid",
                  {
                      type: google.maps.MapTypeId.HYBRID,
                      sphericalMercator: true
                  });
                  var gter = new OpenLayers.Layer.Google("Google Terrain",
                  {
                      type: google.maps.MapTypeId.TERRAIN,
                      sphericalMercator: true
                  });

                  // Create Bing layers
                  var broad = new OpenLayers.Layer.Bing({
                      name: "Bing Roads",
                      key: "INSERT_YOUR_KEY_HERE",
                      type: "Road",
                      sphericalMercator: true
                  });
                  var baer = new OpenLayers.Layer.Bing({
                      name: "Bing Aerial",
                      key: "INSERT_YOUR_KEY_HERE",
                      type: "Aerial",
                      sphericalMercator: true
                  });
                  var bhyb = new OpenLayers.Layer.Bing({
                      name: "Bing Hybrid",
                      key: "INSERT_YOUR_KEY_HERE",
                      type: "AerialWithLabels",
                      sphericalMercator: true
                  });

                  // Create OSM layer
                  var osm = new OpenLayers.Layer.OSM("OpenStreetMap");

                  // create TMS Overlay layer
                   var tmsoverlay = new OpenLayers.Layer.TMS("TMS Overlay", "",
                  {
                      serviceVersion: '.',
                      layername: '.',
                      alpha: true,
                      type: 'png',
                      isBaseLayer: false,
                      getURL: getURL
                  });
                  if (OpenLayers.Util.alphaHack() == false) {
                      tmsoverlay.setOpacity(0.7);
                  }

                  map.addLayers([gmap, gsat, ghyb, gter,
                                 broad, baer, bhyb,
                                 osm, tmsoverlay]);

                  var switcherControl = new OpenLayers.Control.LayerSwitcher();
                  map.addControl(switcherControl);
                  switcherControl.maximizeControl();

                  map.zoomToExtent(mapBounds.transform(map.displayProjection, map.projection));
          
                  map.addControls([new OpenLayers.Control.PanZoomBar(),
                                   new OpenLayers.Control.Navigation(),
                                   new OpenLayers.Control.MousePosition(),
                                   new OpenLayers.Control.ArgParser(),
                                   new OpenLayers.Control.Attribution()]);
                                   
                                   anno.makeAnnotatable(map);
                                   
                                   anno.addPlugin('PolygonSelector', {
                               		activate : true
                               	});
                                   
                                   getAria = function(points) {
                           			var point1, base, sum = 0, point2, size, origPoints = [];
                           			for (var i = 0; i < points.length; i++) {
                           				origPoints.push({
                           					x : points[i].x * map.style.width,
                           					y : points[i].y * map.style.height
                           				});
                           			}
                           			;
                           			point1 = origPoints[0];
                           			base = origPoints[0]
                           			for (var i = 1; i < origPoints.length; i++) {
                           				point2 = origPoints[i];
                           				sum = sum + (point1.x * point2.y - point1.y * point2.x);
                           				point1 = point2;
                           			}
                           			sum = sum + (point1.x * base.y - point1.y * base.x);
                           			sum = Math.abs(sum / 2);
                           			return sum
                           		}

                           		anno.addHandler('onPopupShown',
                           						function(annotation) {
                           							goog.dom.query('.annotorious-popup-text',
                           									this.element)[0].innerHTML = 'Path Name: '
                           									+ annotation.text + ' <br/>Area: '
                           									+ annotation.area;
															
                           							$(".displaySection").find(".highlightArea")
                           									.removeClass("highlightArea");
                           							$("#" + annotation.id).addClass("highlightArea");
                           						});

                           		anno.addHandler('onAnnotationCreated',
                           						function(annotation) {
                           							var d = new Date();
                           							var id = d.getTime();
                           							annotation.id = id;
                           							annotation.area = annotation.shapes[0].geometry.height * annotation.shapes[0].geometry.width;
                           							$(".displaySection")
                           									.append(
                           											"<div class=\"measureSection\" id=" + id + "><label class=\"area-label\">"
                           													+ annotation.text
                           													+ "</label><p id=\"areaLayout\">Plotted Area : <span class=\"badge\">"
                           													+ annotation.area
                           													+ "</span></p><button class=\"btn btn-default viewbtn\" data-toggle=\"modal\" data-area-id="+ id +" data-target=\"#viewDoc\">View Documents</button><button class=\"btn btn-default addbtn\" data-toggle=\"modal\" data-area-id="+ id +" data-target=\"#addDoc\">Add Documents</button></div>")

                           							$(".measureSection").click(
                           									function() {
                           										anno.highlightAnnotation(annotation);
                           										$(".displaySection").find(
                           												".highlightArea").removeClass(
                           												"highlightArea");
                           										$(this).addClass("highlightArea");
                           									});

                           						});
              }
          
              function getURL(bounds) {
                  bounds = this.adjustBounds(bounds);
                  var res = this.getServerResolution();
                  var x = Math.round((bounds.left - this.tileOrigin.lon) / (res * this.tileSize.w));
                  var y = Math.round((bounds.bottom - this.tileOrigin.lat) / (res * this.tileSize.h));
                  var z = this.getServerZoom();
                  if (this.map.baseLayer.CLASS_NAME === 'OpenLayers.Layer.Bing') {
                      z+=1;
                  }
                  var path = this.serviceVersion + "/" + this.layername + "/" + z + "/" + x + "/" + y + "." + this.type;
                  var url = this.url;
                  if (OpenLayers.Util.isArray(url)) {
                      url = this.selectUrl(path, url);
                  }
                  if (mapBounds.intersectsBounds(bounds) && (z >= mapMinZoom) && (z <= mapMaxZoom)) {
                      return url + path;
                  } else {
                      return emptyTileURL;
                  }
              }
          
           function getWindowHeight() {
                if (self.innerHeight) return self.innerHeight;
                    if (document.documentElement && document.documentElement.clientHeight)
                        return document.documentElement.clientHeight;
                    if (document.body) return document.body.clientHeight;
                        return 0;
                }

                function getWindowWidth() {
                    if (self.innerWidth) return self.innerWidth;
                    if (document.documentElement && document.documentElement.clientWidth)
                        return document.documentElement.clientWidth;
                    if (document.body) return document.body.clientWidth;
                        return 0;
                }

                function resize() {
                    var map = document.getElementById("map");
                    map.style.height = (getWindowHeight()-80) + "px";
                    map.style.width = (getWindowWidth()-20) + "px";
                    if (map.updateSize) { map.updateSize(); };
                }
                
                function annotate() {
                	anno.activateSelector();
					anno.setCurrentSelector("polygon");
                }

                onresize=function(){ resize(); };
	
	
				
</script>
</head>

<body onload="init()";>


	<div class="content">
		<div class="col-sm-9">
			<div id="map"></div>
		</div>
		<div class="col-sm-3">
			<h4><a id="map-annotate-button" onclick="annotate();" href="#">ADD ANNOTATION</a></h4>
			<h4>Test Project</h4>
			<div class="displaySection">
				<h5>Measurements</h5>
			</div>
			<h4><a id="map-annotate-button" data-toggle="modal" data-target="#panaroma" href="#openPanaroma">Open Panaroma</a></h4>
		</div>
	</div>

	<!-- View Documents Modal -->
	<div class="modal fade" id="viewDoc" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Modal Header</h4>
				</div>
				<div class="modal-body">
					<%--  <% 
String file =  getServletContext().getRealPath("/")  + "/uploads";
File f = new File(file);
String [] fileNames = f.list();
File [] fileObjects= f.listFiles();
%> --%>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

	<!-- Add Documents Modal -->
	<div class="modal fade" id="addDoc" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"></button>
					<h4 class="modal-title">Add Documents</h4>
				</div>
				<div class="modal-body">
					<form method="post" enctype="multipart/form-data">
						<input id="hideId" name="hideId"> Select file to upload: <input
							type="file" name="file" class="uploadFile" size="60" /><br /> <br />
						<div class="modal-footer">
							<input type="submit" class="btn btn-primary" value="Upload" />
							<!-- <button type="button" class="btn btn-default" data-dismiss="modal">Close</button> -->
						</div>
					</form>
				</div>

			</div>

		</div>
	</div>
	
		<div class="modal fade" id="panaroma" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"></button>
				</div>
				<div class="modal-body">
					<div onload="init_pano('canvas')" width="640" height="480">
					  <br>
					  <canvas id="canvas" width="640" height="480">
					  </canvas> <br>
					</div>
				</div>

			</div>

		</div>
	</div>
	
	<footer> </footer>
	<script type="text/javascript" src="latest/annotorious.full.js"></script>
	<script type="text/javascript" src="latest/annotorious.min.js"></script>
	<script type="text/javascript" src="latest/anno-polygon.min.js"></script>
	<script type="text/javascript" src="latest/html5pano.js"></script>
	<script type="text/javascript">resize()</script>
	<script>
		$('#addDoc').on('show.bs.modal', function(event) {
			var id = $(event.relatedTarget).data('area-id');
			$("#hideId").attr("value", id);
		});
		$(':file').on('change', uploadFile);
		function uploadFile(event) {
			event.stopPropagation();
			event.preventDefault();
			var files = event.target.files;
			var data = new FormData();
			data.append("annotationId", $("#hideId").attr("value"));
			$.each(files, function(key, value) {
				data.append(key, value);
			});
			postFilesData(data);
		}

		function postFilesData(data) {
			$.ajax({
				url : 'UploadDocumentServlet',
				type : 'POST',
				cache : false,
				data : data,
				mimeType : 'multipart/form-data',
				processData : false,
				contentType : false,
				success : function(data, textStatus, jqXHR) {
					//success
					alert("success");
				},
				error : function(jqXHR, textStatus, errorThrown) {
					console.log('ERRORS: ' + textStatus);
				}
			});
		}
		
		$('#panaroma').on('shown', init_pano('canvas'));
	</script>
</body>
</html>
