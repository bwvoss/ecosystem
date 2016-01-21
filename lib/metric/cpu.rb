require 'usagewatch_ext'

module Metric
  class Cpu
    def percentage_used
      Usagewatch.uw_cpuused
    end

    def top_processes
      processes = Usagewatch.uw_cputop
      processes_to_string = processes.map do |process_data|
        "#{process_data[0]}: #{process_data[1]}"
      end

      processes_to_string.join(', ')
    end
  end
end

