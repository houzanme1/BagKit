class BagKit
  
  class Task < javax.swing.SwingWorker
    include_package 'javax.swing'
    include_package 'javax.swing.text'
    include_package 'java.awt'
    include Profligacy
    
    attr_writer :task
    attr_writer :auto_close
    
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
      tasks = if task.first.is_a? Array then task else [task] end
      tasks.each do |t|
        console_append(Color.black, "executing task:")
        console_append(Color.black, t.join(" "))
        
        process = java.lang.Runtime.runtime.exec(t.to_java(:String))
        out = StreamGrabber.new(process.input_stream) { |text| console_append(Color.black, text) }
        err = StreamGrabber.new(process.error_stream) { |text| console_append(Color.black, text) }
        out.start
        err.start
        exit_code = process.wait_for
        
        if exit_code == 0
          console_append(Color.green, "task finished succesfully")
        else
          self.auto_close = false
          console.foreground = Color.red
          console_append(Color.red, "task finished with exit code: #{exit_code}")
        end
      end
      if auto_close
        ui.visible = false
        ui.dispose
      end
    end
    
    def console
      @console ||= JTextPane.new
    end
    
    def console_append(color, text)
      console.set_caret_position(console.document.length)
      console.set_character_attributes(StyleContext.default_style_context.add_attribute(
        SimpleAttributeSet::EMPTY,
        StyleConstants::Foreground,
        color
      ), false)
      console.replace_selection("#{text}\n")
    end
    
    def task
      @task || raise("missing: task")
    end
    
    def ui
      @ui || raise("missing: ui")
    end
    
    def auto_close
      @auto_close = true if @auto_close.nil?
      @auto_close
    end
    
    module ListLayout
      include_package 'javax.swing'
      include_package 'javax.swing.border'
      include_package 'javax.swing.text'
      include_package 'java.awt'
      include Profligacy
      
      attr_reader :toolbar, :files, :table
      
      def initialize(t, e)
        @files = BagKit::List.new
        @files.label = list_label
        @table = JTable.new(@files)
        @table.intercell_spacing = Dimension.new(4,0)
        @table.row_height = 24
        
        @toolbar = Swing::Build.new(JToolBar, :add, :clear, :bag) do |c,i|
          c.add   = BagKit.build_toolbar_button text_button_add
          c.clear = BagKit.build_toolbar_button text_button_remove_all
          c.bag   = BagKit.build_toolbar_button text_button_bagit
          
          i.add   = { :action => method(:action_add) }
          i.clear = { :action => proc { |t,e| files.clear } }
          i.bag   = { :action => method(:action_bag) }
        end.build("Toolbar") do |t|
          t.floatable = false
        end
        
        @ui = Swing::LEL.new(JFrame, layout) do |c,i|
          c.toolbar = toolbar
          c.files   = JScrollPane.new(table)
          c.console = JScrollPane.new(console)
          if block_given?
            yield c, i
          end
        end.build(:args => text_window) do |f|
          f.default_close_operation = JFrame::DISPOSE_ON_CLOSE
        end
        
        super()
      end
      
      def text_window
        raise("missing: text_window")
      end
      
      def text_button_add
        "Add files"
      end
      
      def text_button_remove_all
        "Remove all"
      end
      
      def text_button_bagit
        "Bagit"
      end
      
      def text_dialog_title
        "Choose"
      end
      
      def list_label
        "Files"
      end
      
      def layout
        "[<toolbar         ]
         [(500,250)*files  ]
         [(500,250)*console]"
      end
      
      def dialog
        @dialog ||= begin
          d = JFileChooser.new
          d.dialog_title = text_dialog_title
          d
        end
      end
      
      def before_action_add
        
      end
      
      def action_add(type, event)
        before_action_add
        return unless dialog.show_open_dialog(nil) == JFileChooser::APPROVE_OPTION
        files.add(*dialog.selected_files)
      end
      
      def action_bag(type, event)
        raise("missing: action_bag")
      end
    end
    
  end
  
end
