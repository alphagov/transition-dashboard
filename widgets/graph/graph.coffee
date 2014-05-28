class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')

  ready: ->
    container = $(@node).parent()
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'line'
      series: [
        {
          color: "#10b5ad",
          data: [{x:0, y:0}]
        },
        {
          color: "#fec04c",
          data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('actual') if @get('actual')
    @graph.series[1].data = @get('expected') if @get('expected')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.renderer.unstack = true
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data[0] = data.points[0][0]
      @graph.series[1].data[1] = data.points[1][1]
      @graph.render()
