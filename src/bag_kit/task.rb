class BagKit
  
  class Task < javax.swing.SwingWorker
    include_package 'javax.swing'
    include_package 'java.awt'
    include Profligacy
    
    def self.base_task
      @base_task ||= [
        'java',
        '-Xmx512m',
        '-classpath',
        Context.local_path("#{Context.root}/bagit/lib/classworlds-1.1.jar"),
        '-Dclassworlds.conf=' + Context.local_path("#{Context.root}/bagit/bin/bag.classworlds.conf"),
        '-Dapp.home=' + Context.local_path("#{Context.root}/bagit"),
        '-Dlog_file=' + Context.local_path("#{Context.root}/bagit.log"),
        'org.codehaus.classworlds.Launcher',
      ]
    end
    
    def doInBackground
      @console.append("executing task:\n#{@task.join(' ')}\n")
      
      process = java.lang.Runtime.runtime.exec(@task.to_java(:String))
      out = StreamGrabber.new(process.input_stream) { |text| @console.append("#{text}\n") }
      err = StreamGrabber.new(process.error_stream) { |text| @console.append("#{text}\n") }
      out.start
      err.start
      exit_code = process.wait_for
      
      @console.append("task finished with exit code: #{exit_code}\n")
      
      if exit_code == 0
        @ui.visible = false
        @ui.dispose
      end
    end
    
    def initialize(*args)
      @task = self.class.base_task + args
      
      @console = JTextArea.new
      @console.editable  = false
      @console.line_wrap = true
      
      @ui = Swing::LEL.new(JFrame, "[(500,200)*console]") do |c,i|
        c.console = JScrollPane.new(@console)
      end.build(:args => "Console") do |f|
        f.default_close_operation = JFrame::DISPOSE_ON_CLOSE
      end
      
      super()
    end
  end
  
end
