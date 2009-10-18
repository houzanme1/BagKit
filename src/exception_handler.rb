class ExceptionHandler
  include java.lang.Thread::UncaughtExceptionHandler
  
  def self.on_error(&block)
    java.lang.Thread.default_uncaught_exception_handler = self.new(&block)
  end
  
  def initialize(&block)
    @block = block
  end
  
  def uncaughtException(thread, exception)
    @block.call(exception, thread)
  end
end
