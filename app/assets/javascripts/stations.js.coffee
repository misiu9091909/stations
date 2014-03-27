# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
class CustomMarkerBuilder extends Gmaps.Google.Builders.Marker
  create_marker: ->
    options = _.extend @marker_options(), @rich_marker_options()
    @serviceObject = new RichMarker options

  rich_marker_options: ->
    marker = document.createElement("div")
    marker.setAttribute('class', 'label label-success')
    marker.setAttribute("bgcolor", '#ffffff')
    marker.innerHTML = this.args.custom_marker
    { content: marker }

  create_infowindow: ->
    return null unless _.isString @args.custom_infowindow

    boxText = document.createElement("div")
    boxText.setAttribute("class", 'custom_infowindow_content')

    boxText.innerHTML = @args.custom_infowindow
    @infowindow = new InfoBox(@infobox(boxText))

  infobox: (boxText)->
    content: boxText

    boxStyle:
      width: "280px"


handler = Gmaps.build("Google", builders: { Marker: CustomMarkerBuilder } )
handler.buildMap { internal: id: "custom_builder" }, ->
  marker = handler.addMarker
    lat:               40.689167
    lng:               -74.044444
    custom_marker:     "<div style='font-color: blue'> Statue of Liberty </div>"
    custom_infowindow: "<img src='images/statue.jpg' width='90' height='140'> The Statue of Liberty is a colossal neoclassical sculpture on Liberty Island in the middle of New York"

  handler.map.centerOn marker
  handler.getMap().setZoom(15)