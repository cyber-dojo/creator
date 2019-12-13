require 'minitest/autorun'

class HexMiniTest < MiniTest::Test

  def initialize(arg)
    super(arg)
  end

  @@args = (ARGV.sort.uniq - ['--'])
  @@seen_hex_ids = []
  @@timings = {}

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.test(hex_suffix, *lines, &test_block)
    src = test_block.source_location
    src_file = File.basename(src[0])
    src_line = src[1].to_s
    hex_id = checked_hex_id(hex_suffix, lines)
    if @@args === [] || @@args.any?{ |arg| hex_id.include?(arg) }
      hex_name = lines.join(space = ' ')
      execute_around = lambda {
        _hex_setup_caller(hex_id, hex_name)
        begin
          t1 = Time.now
          self.instance_eval(&test_block)
          t2 = Time.now
          @@timings[hex_id+':'+src_file+':'+src_line+':'+hex_name] = (t2 - t1)
        ensure
          puts $!.message unless $!.nil?
          _hex_teardown_caller
        end
      }
      name = "hex '#{hex_id}',\n'#{hex_name}'"
      define_method("test_\n#{name}".to_sym, &execute_around)
    end
  end

  ObjectSpace.define_finalizer(self, proc {
    slow = @@timings.select{ |_name,secs| secs > 0.000 }
    sorted = slow.sort_by{ |name,secs| -secs }.to_h
    size = sorted.size < 5 ? sorted.size : 5
    puts "Slowest #{size} tests are..." if size != 0
    sorted.each_with_index { |(name,secs),index|
      puts "%3.4f - %-72s" % [secs,name]
      break if index == size
    }
    puts
  })

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.checked_hex_id(hex_suffix, lines)
    method = 'def self.hex_prefix'
    pointer = ' ' * method.index('.') + '!'
    pointee = (['',pointer,method,'','']).join("\n")
    pointer.prepend("\n\n")
    raise "#{pointer}missing#{pointee}" unless respond_to?(:hex_prefix)
    raise "#{pointer}empty#{pointee}" if hex_prefix === ''
    raise "#{pointer}not hex#{pointee}" unless hex_prefix =~ /^[0-9A-Fa-f]+$/

    method = "test '#{hex_suffix}',"
    pointer = ' ' * method.index("'") + '!'
    proposition = lines.join(space = ' ')
    pointee = ['',pointer,method,"'#{proposition}'",'',''].join("\n")
    hex_id = hex_prefix + hex_suffix
    pointer.prepend("\n\n")
    raise "#{pointer}empty#{pointee}" if hex_suffix === ''
    raise "#{pointer}not hex#{pointee}" unless hex_suffix =~ /^[0-9A-Fa-f]+$/
    raise "#{pointer}duplicate#{pointee}" if @@seen_hex_ids.include?(hex_id)
    raise "#{pointer}overlap#{pointee}" if hex_prefix[-2..-1] === hex_suffix[0..1]
    @@seen_hex_ids << hex_id
    hex_id
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def _hex_setup_caller(hex_id, hex_name)
    ENV['CYBER_DOJO_HEX_TEST_ID'] = hex_id
    @_hex_test_id = hex_id
    @_hex_test_name = hex_name
    hex_setup
  end

  def _hex_teardown_caller
    hex_teardown
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def hex_test_id
    @_hex_test_id
  end

  def hex_setup
  end

  def hex_teardown
  end

end
