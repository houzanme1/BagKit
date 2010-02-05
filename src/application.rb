current_dir = File.expand_path(File.dirname(__FILE__))
project_dir = File.join(current_dir, '..')

require 'java'

Dir.glob(File.join(project_dir, 'lib', 'java', '**', '*.jar')).each { |jar| $CLASSPATH << jar }

$LOAD_PATH.clear
$LOAD_PATH << current_dir
$LOAD_PATH << File.join(project_dir, 'lib', 'ruby')

require 'context'
require 'exception_handler'
require 'stream_grabber'
require 'bag_kit'
require 'bag_kit/list'
require 'bag_kit/task'
require 'bag_kit/task/create'
require 'bag_kit/task/update'
require 'bag_kit/task/in_place'
require 'bag_kit/task/validate'

javax.swing.UIManager.look_and_feel = javax.swing.UIManager.system_look_and_feel_class_name
if Context.mac
  java.lang.System.set_property("apple.laf.useScreenMenuBar", "true")
end

def handle_exception(exception, thread = nil)
  title = 'Application Error'
  descr = 'The application has encountered a fatal error and must shut down.'
  trace = if exception.kind_of? Exception
    exception.backtrace.join("\n")
  else
    output = java.io.ByteArrayOutputStream.new
    exception.print_stack_trace(java.io.PrintStream.new(output_stream))
    output
  end
  
  STDERR.puts title
  STDERR.puts descr
  STDERR.puts trace
  
  javax.swing.JOptionPane.show_message_dialog(nil, descr, title, javax.swing.JOptionPane::DEFAULT_OPTION)
  java.lang.System.exit(0)
end

if Context.jar
  ExceptionHandler.on_error { |exception, thread| handle_exception(exception, thread) }
end

begin
  SwingUtilities.invoke_later proc { BagKit.new }.to_runnable
rescue => exception
  handle_exception(exception)
end
