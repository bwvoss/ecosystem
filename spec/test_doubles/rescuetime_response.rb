module TestDoubles
  module RescuetimeResponse
    def self.headers
      [
        'Date',
        'Time Spent (seconds)',
        'Number of People',
        'Activity',
        'Category',
        'Productivity'
      ]
    end

    def self.rows
      [
        ['2015-10-02T08:35:00', 105, 1, 'Terminal', 'Systems Operations', 2],
        ['2015-10-02T08:35:00', 54, 1, 'slack.com', 'Instant Message', -1],
        ['2015-10-02T08:35:00', 10, 1, 'logswan.org', 'Uncategorized', 0],
        ['2015-10-02T08:35:00', 1, 1, 'linuxfoundation.org', 'Search', 0],
        ['2015-10-02T08:35:00', 1, 1, 'Gmail', 'Email', 0]
      ]
    end
  end
end

