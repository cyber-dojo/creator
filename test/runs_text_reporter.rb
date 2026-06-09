require 'minitest/reporters'

# Overrides only report to use 'runs' terminology so cyberdojo/check-test-metrics
# can parse the 'Finished in Xs, Y runs/s' and 'N runs, N assertions...' lines.
class RunsTextReporter < Minitest::Reporters::BaseReporter
  # Delegates to super for failure details then prints the summary in 'runs' format.
  def report
    super
    io.printf("Finished in %.6fs, %.4f runs/s, %.4f assertions/s.\n\n",
              total_time, count / total_time, assertions / total_time)
    io.puts "#{count} runs, #{assertions} assertions, " \
            "#{failures} failures, #{errors} errors, #{skips} skips"
  end
end
