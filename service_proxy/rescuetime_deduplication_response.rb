require_relative 'rescuetime_response'

module RescuetimeDeduplicationResponse
  def self.response
    {
      "notes" => "data is an array of arrays (rows), column names for rows in row_headers",
      "row_headers" => ["Date", "Time Spent (seconds)", "Number of People", "Activity", "Category", "Productivity"],
      "rows" => RescuetimeResponse.rows + self.rows
    }
  end

  def self.rows
    [
      ["2015-10-02T09:50:00", 70, 1, "shophex.com", "Uncategorized", 0],
      ["2015-10-02T09:50:00", 43, 1, "kk.org", "General News & Opinion", -2],
      ["2015-10-02T09:50:00", 14, 1, "google.com", "Search", 0],
      ["2015-10-02T09:50:00", 7, 1, "newtab", "Browsers", 0],
      ["2015-10-02T09:55:00", 115, 1, "etsy.com", "General Shopping", -2],
      ["2015-10-02T09:55:00", 52, 1, "kk.org", "General News & Opinion", -2],
      ["2015-10-02T09:55:00", 45, 1, "amazon.com", "General Shopping", -2],
      ["2015-10-02T09:55:00", 33, 1, "en.dawanda.com", "Uncategorized", 0],
      ["2015-10-02T09:55:00", 28, 1, "google.com", "Search", 0],
      ["2015-10-02T09:55:00", 13, 1, "newtab", "Browsers", 0],
      ["2015-10-02T09:55:00", 8, 1, "Google Hangouts", "Instant Message", -1]
    ]
  end
end
