describe 'Understanding transactional performance' do
  xit 'returns a timeseries system snapshot during a transaction', services: [:rds] do
    run_id = 1
    metrics = Metrics::Performance.for(run_id)

    expect(metrics).to eq(
      run_id: run_id,
      duration: 5.67,
      action_durations: {
        'TestAction': 1.24,
        'OtherAction': 4.43
      },
      timeseries: {
        every: 0.5,
        metrics: [
          {
            time: '',
            current_action: 'TestAction',
            cpu: 2.94
          }
        ]
      }
    )
  end
end

