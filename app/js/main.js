
// var zipcode_Issues = new ol.layer.Tile({
//     //extent: [-173, 8.3, -43, 77],
//     source: new ol.source.TileWMS(/** @type {olx.source.TileWMSOptions} */ ({
//       url: 'http://geonode.edip-maps.net/geoserver/geonode/wms',
//       params: {'LAYERS': 'geonode:zipcode_issuance_wgs84', 'TILED': true, 'preload': 1},
//       serverType: 'geoserver'
//     }))
//   });

/**
 * Elements that make up the popup.
 */
var container = document.getElementById('popup');
var content = document.getElementById('popup-content');
var closer = document.getElementById('popup-closer');


/**
 * Add a click handler to hide the popup.
 * @return {boolean} Don't follow the href.
 */
closer.onclick = function() {
  container.style.display = 'none';
  closer.blur();
  return false;
};


/**
 * Create an overlay to anchor the popup to the map.
 */
var overlay = new ol.Overlay({
  element: container
});






var baseLayer = new ol.layer.Tile({
    //extent: [-173, 8.3, -43, 77],
    source: new ol.source.TileWMS(/** @type {olx.source.TileWMSOptions} */ ({
      url: 'http://54.197.226.119:8080/geoserver/natural-earth-rasters/wms',
      params: {'LAYERS': 'natural-earth-rasters:GRAY_50M_SR', 'TILED': true, 'preload': 1},
      serverType: 'geoserver'
    }))
});

var zipcode_Issues = new ol.layer.Tile({
    //extent: [-173, 8.3, -43, 77],
    source: new ol.source.TileWMS(/** @type {olx.source.TileWMSOptions} */ ({
      url: 'http://geonode.edip-maps.net/geoserver/geonode/wms',
      params: {'LAYERS': 'geonode:zipcode_issuance_wgs84', 'TILED': true, 'preload': 1},
      serverType: 'geoserver'
    }))
  });


var countiesPopulation = new ol.layer.Tile({
    //extent: [-173, 8.3, -43, 77],
    source: new ol.source.TileWMS(/** @type {olx.source.TileWMSOptions} */ ({
      url: 'http://geonode.edip-maps.net/geoserver/geonode/wms',
      params: {'LAYERS': 'geonode:counties_population_2013', 'TILED': true, 'preload': 1},
      serverType: 'geoserver'
    }))
  });




var questionnaire_layer = new ol.layer.Tile({
    //extent: [-173, 8.3, -43, 77],
    source: new ol.source.TileWMS(/** @type {olx.source.TileWMSOptions} */ ({
      url: 'http://geonode.edip-maps.net/geoserver/geonode/wms',
      params: {'LAYERS': 'geonode:acceptance_facilities_questionnaire', 'TILED': true, 'preload': 1},
      serverType: 'geoserver'
    }))
  });

var view = new ol.View({
    center: ol.proj.transform([-96,40], 'EPSG:4326', 'EPSG:3857'),
    //center: [0, 0],
    zoom: 4,
    maxZoom:11
  })


var map = new ol.Map({
  layers: [baseLayer, zipcode_Issues, countiesPopulation, questionnaire_layer],
  target: 'map',
  controls: ol.control.defaults({
    attributionOptions: /** @type {olx.control.AttributionOptions} */ ({
      collapsible: false
    })
  }),
  overlays: [overlay],
  view: view
});

var swipe = document.getElementById('swipe');

countiesPopulation.on('precompose', function(event) {
  var ctx = event.context;
  var width = ctx.canvas.width * (swipe.value / 100);

  ctx.save();
  ctx.beginPath();
  ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
  ctx.clip();
});

countiesPopulation.on('postcompose', function(event) {
  var ctx = event.context;
  ctx.restore();
});

swipe.addEventListener('input', function() {
  map.render();
}, false);



var JSONcallback = function(data){
  console.log(data);
}

var drawTable = function(features){
  var LIMIT = 5;
  var count = 0;
  var tempoutput = "<table>";
  $.each(features[0].properties, function(index, value){
    if (count > LIMIT){
      return false;
    }
    count += 1;
    tempoutput += "<tr><td>" + index + "</td><td>" + value + "</td></tr>";
  });
  tempoutput = tempoutput + "</table>";
  return tempoutput

}

var renderBottom_AF = function(features){

}

var renderBottom_Pop = function(features){

}

var renderBottom_Issued = function(features){

}


/**
 * Add a click handler to the map to render the popup.
 */
var popupajax = null;
map.on('singleclick', function(evt) {

  var viewResolution = /** @type {number} */ (view.getResolution());
  var url = questionnaire_layer.getSource().getGetFeatureInfoUrl(
      evt.coordinate, viewResolution, 'EPSG:3857',
      {'INFO_FORMAT': 'application/json'});
  if (url) {
    $.ajax({
      url: url,// + "&callback=JSONcallback",
      dataType:"json",
      crossDomain:true
    }).success(function( data ) {
        if (data.features.length > 0){
          var contentvalue = drawTable(data.features);
          console.log(contentvalue);
          $("#popup-content").html(contentvalue);
          renderBottom_AF(data.features);

        }
        else{
          $("#popup-content").html("No Acceptance Facility at this site");
        }

      });

  var url = questionnaire_layer.getSource().getGetFeatureInfoUrl(
      evt.coordinate, viewResolution, 'EPSG:3857',
      {'INFO_FORMAT': 'application/json'});

  var url = questionnaire_layer.getSource().getGetFeatureInfoUrl(
      evt.coordinate, viewResolution, 'EPSG:3857',
      {'INFO_FORMAT': 'application/json'});


    var thegetter = [{"url":null, "callback":null}


  }


  var coordinate = evt.coordinate;
  var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
      coordinate, 'EPSG:3857', 'EPSG:4326'));

  overlay.setPosition(coordinate);
  content.innerHTML = '<div class="loader"></div>';
  container.style.display = 'block';

});