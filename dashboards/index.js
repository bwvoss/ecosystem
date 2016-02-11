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
  render: function() {
    return (
      <div className="col-lg-3">
        <div className="ibox float-e-margins">
          <div className="ibox-title">
            <h5>{this.props.run_uuid}</h5>
          </div>
          <div className="ibox-content">
            <h1 className="no-margins">{this.props.duration}</h1>
            <small>Seconds</small>
          </div>
        </div>
      </div>
    );
  }
});

var RunsOverview = React.createClass({
  render: function() {
    var tiles = this.props.data.map(function(runData) {
      return(
        <RunTile duration={runData.duration.toString()} run_uuid={runData.run_uuid} />
      )
    });

    return (
      <div className="row">
        {tiles}
      </div>
    );
  }
});

$.get('http://localhost:8000/runs', function (data) {
  ReactDOM.render(<RunsOverview data={data} />, document.querySelector('#runs-overview'));
});

