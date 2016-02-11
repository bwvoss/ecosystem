// var ReactChart = React.createClass({
//   componentDidMount: function () {
//     var data = {
//       labels: ['1', '2', '3'],
//       series: [[100, 200, 30, 234]]
//     }
//     this.updateChart(data);
//   },
//
//   updateChart: function (data) {
//     return new Chartist.Line('.chart', data);
//   },
//
//   render: function () {
//     return React.createElement('div', { className: 'chart' });
//   }
// });

// var App = React.createClass({
//   render: function () {
//     return React.createElement(ReactChart, { source: 'http://localhost:8000/duration/1234'});
//   }
// });
//

var RunTile = React.createClass({
  displayName: "RunTile",

  render: function () {
    return React.createElement(
      "div",
      { className: "col-lg-3" },
      React.createElement(
        "div",
        { className: "ibox float-e-margins" },
        React.createElement(
          "div",
          { className: "ibox-title" },
          React.createElement(
            "h5",
            null,
            this.props.run_uuid
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
      return React.createElement(RunTile, { duration: runData.duration.toString(), run_uuid: runData.run_uuid });
    });

    return React.createElement(
      "div",
      { className: "row" },
      tiles
    );
  }
});

$.get('http://localhost:8000/runs', function (data) {
  ReactDOM.render(React.createElement(RunsOverview, { data: data }), document.querySelector('#runs-overview'));
});