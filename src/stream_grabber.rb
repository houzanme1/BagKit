class StreamGrabber < java.lang.Thread
  include_package 'java.io'
  
  def initialize(input, &block)
    @input = BufferedReader.new(InputStreamReader.new(input))
    @block = block
    super()
  end
  
  def run
    while line = @input.read_line
      @block.call(line)
    end
  end
end
