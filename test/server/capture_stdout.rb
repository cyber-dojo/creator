# frozen_string_literal: false # [1]

module CaptureStdout

  def capture_stdout
    begin
      uncaptured = $stdout
      captured = StringIO.new('', 'w') # [1]
      $stdout = captured
      yield uncaptured
      $stdout.string
    ensure
      $stdout = uncaptured
    end
  end

end
