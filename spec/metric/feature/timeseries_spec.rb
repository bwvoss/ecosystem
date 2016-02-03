# describe 'Understanding transactional performance' do
  # it 'returns a timeseries system snapshot during a transaction' do
# TODO: each one will be contoured for what I need to know when investigating
    # metrics = Metrics::Performance.for(run_id)

    # expect(metrics).to eq(
      # run_id: 1,
      # duration: 5.67,
      # action_durations: {
        # 'TestAction': 1.24,
        # 'OtherAction': 4.43
      # },
      # timeseries: {
        # every: 0.5,
        # metrics: [
          # {
            # time: '',
            # current_action: 'TestAction',
            # system_metrics: {
              # cpu:
              # ram:
            # }
          # }
        # ]
      # }
    # )
  # end
# end

# TODO: OR:
# describe 'Understanding system conditions from metrics' do
  # it 'allows the operator to understand how something works in the system' do
    # monitor = Monitors::Run.new(run_id, maybe connector_id)

    # expect(monitor.inspect).to eq(
      # :start_time => "2016-01-12 10:24 25 UTC",
      # :end_time => "2016-01-12 10:24 30 UTC",
      # :context_result => :failed,
      # :duration => 5.53,
      # :action_durations => {
        # :ParsesPayloadAction => 3.32,
        # :SavesEntitiesAction => 2.21
      # },
      # :data_size => {
        # :file_size => '5.6KB',
        # :assets => 1,
        # :vulnerabilities => 7345
      # },
      # :timeseries => [
        # {
          # :time => "",
          # :current_action => 'ParsesPayloadAction',
          # :system_metrics => {
            # :cpu_percentage => 45.7,
            # :ram_percentage => 34.2
          # },
          # :services => {
            # :database => {
              # :connections => 2,
              # :transactions => 0
            # },
            # :elasticsearch => {
              # :connections => 1,
              # :transactions => 0
            # }
          # }
        # }
      # ]
    # )
  # end
# end

