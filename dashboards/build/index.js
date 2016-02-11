var RunTile = React.createClass({
  displayName: "RunTile",

  render: function () {
    return React.createElement(
      "div",
      { className: "col-lg-3", onClick: this.props.onTileClick.bind(this, this.props.runUuid) },
      React.createElement(
        "div",
        { className: "ibox float-e-margins" },
        React.createElement(
          "div",
          { className: "ibox-title" },
          React.createElement(
            "h5",
            null,
            this.props.runUuid
          )
        ),
        React.createElement(
          "div",
          { className: "ibox-content" },
          React.createElement(
            "h1",
            { className: "no-margins" },
            this.props.duration
          ),
          React.createElement(
            "small",
            null,
            "Seconds"
          )
        )
      )
    );
  }
});

var RunsOverview = React.createClass({
  displayName: "RunsOverview",

  render: function () {
    var tiles = this.props.data.map(function (runData) {
      return React.createElement(RunTile, { duration: runData.duration.toString(), runUuid: runData.run_uuid, onTileClick: this.props.onTileClick });
    }.bind(this));

    return React.createElement(
      "div",
      { className: "row" },
      tiles
    );
  }
});

var ReactChart = React.createClass({
  displayName: "ReactChart",

  componentDidMount: function () {
    $.get('http://localhost:8000/runs/' + this.props.runUuid + '/duration', function (response) {
      var data = {
        labels: response.map(function (actionData) {
          return actionData.action;
        }),
        series: [response.map(function (actionData) {
          return actionData.duration;
        })]
      };

      this.updateChart(data);
    }.bind(this));
  },

  updateChart: function (data) {
    return new Chartist.Bar('#ct-chart', data);
  },

  render: function () {
    return React.createElement(
      "div",
      { className: "col-lg-12" },
      React.createElement(
        "div",
        { className: "ibox float-e-margins" },
        React.createElement(
          "div",
          { className: "ibox-title" },
          React.createElement(
            "h5",
            null,
            "Action Durations"
          )
        ),
        React.createElement(
          "div",
          { className: "ibox-content" },
          React.createElement("div", { id: "ct-chart" })
        )
      )
    );
  }
});

var renderTileMetrics = function (runUuid) {
  ReactDOM.render(React.createElement(ReactChart, { runUuid: runUuid }), document.querySelector('#runs-overview'));
};

$.get('http://localhost:8000/runs', function (data) {
  ReactDOM.render(React.createElement(RunsOverview, { data: data, onTileClick: renderTileMetrics }), document.querySelector('#runs-overview'));
});