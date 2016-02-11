var RunTile = React.createClass({
  render: function() {
    return (
      <div className="col-lg-3" onClick={this.props.onTileClick.bind(this, this.props.runUuid)}>
        <div className="ibox float-e-margins">
          <div className="ibox-title">
            <h5>{this.props.runUuid}</h5>
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
        <RunTile duration={runData.duration.toString()} runUuid={runData.run_uuid} onTileClick={this.props.onTileClick}/>
      )
    }.bind(this));

    return (
      <div className="row">
        {tiles}
      </div>
    );
  }
});

var ReactChart = React.createClass({
  componentDidMount: function () {
    $.get('http://localhost:8000/runs/' + this.props.runUuid + '/duration', function(response) {
      var data = {
        labels: response.map(function(actionData) { return actionData.action }),
        series: [response.map(function(actionData) { return actionData.duration})]
      }

      this.updateChart(data);
    }.bind(this));
  },

  updateChart: function (data) {
    return new Chartist.Bar('#ct-chart', data);
  },

  render: function () {
    return(
      <div className="col-lg-12">
        <div className="ibox float-e-margins">
          <div className="ibox-title">
            <h5>Action Durations</h5>
          </div>
          <div className="ibox-content">
            <div id="ct-chart"></div>
          </div>
        </div>
      </div>
    )
  }
});

var renderTileMetrics = function(runUuid) {
  ReactDOM.render(<ReactChart runUuid={runUuid} />, document.querySelector('#runs-overview'));
}

$.get('http://localhost:8000/runs', function (data) {
  ReactDOM.render(<RunsOverview data={data} onTileClick={renderTileMetrics}/>, document.querySelector('#runs-overview'));
});

