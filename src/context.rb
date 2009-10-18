module Context
  
  @location = if File.expand_path(__FILE__).include? '.jar!' then :jar else :src end
  
  @os = case java.lang.System.get_property('os.name')
  when /linux/i   then :linux
  when /mac\sos/i then :mac
  when /windows/i then :windows
  when /solaris/i then :solaris
  when /freebsd/i then :freebsd
  end
  
  def self.local_path(path)
    if @os == :windows
      path.gsub!(/\%20/, "\ ")
      path.gsub!(/\//, "\\")
    end
    path
  end
  
  @root = local_path(
    case @location
    when :src
      File.join(File.dirname(File.expand_path($0)), '..')
    when :jar
      file = if @os == :windows
               __FILE__.sub(/^file\:\//, '')
             else
               __FILE__.sub(/^file\:/, '')
             end
      file.sub!(/\.jar\!.+$/, '.jar')
      File.dirname(file)
     end
  )
  
  %w(jar src).each do |name|
    module_eval <<-RUBY
      def self.#{name}(&block)
        if bool = @location == :#{name} and block_given?
          block.call
        end
        bool
      end
    RUBY
  end
  
  %w(linux mac windows solaris freebsd).each do |name|
    module_eval <<-RUBY
      def self.#{name}(&block)
        if bool = @os == :#{name} and block_given?
          block.call
        end
        bool
      end
    RUBY
  end
  
  class << self
    attr_reader :location
    attr_reader :os
    attr_reader :root
  end
end
