class BagKit
  
  class Task::Create < Task
    include_package 'javax.swing'
    include_package 'javax.swing.border'
    include_package 'javax.swing.text'
    include_package 'java.awt'
    include ListLayout
    
    def initialize(*args)
      self.auto_close = false
      
      @option1 = JComboBox.new ["0.96", "0.95", "0.94", "0.93"].to_java(:String)
      @option2 = JComboBox.new ["md5", "sha1", "sha256", "sha512"].to_java(:String)
      @option3 = JComboBox.new ["md5", "sha1", "sha256", "sha512"].to_java(:String)
      @option4 = JComboBox.new ["filesystem", "tar", "tar_gz", "tar_bz2", "zip"].to_java(:String)
      super(*args) do |c, i|
        c.option1_label = JLabel.new "Bagit version:"
        c.option1 = @option1
        c.option2_label = JLabel.new "Payload manifest algorithm:"
        c.option2 = @option2
        c.option3_label = JLabel.new "Tag manifest algorithm:"
        c.option3 = @option3
        c.option4_label = JLabel.new "Write to:"
        c.option4 = @option4
      end
    end
    
    def layout
      "[<toolbar         ]
       [<option1_label   ]
       [<option1         ]
       [<option2_label   ]
       [<option2         ]
       [<option3_label   ]
       [<option3         ]
       [<option4_label   ]
       [<option4         ]
       [(500,250)*files  ]
       [(500,250)*console]"
    end
    
    def text_window
      "Create a bag"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::FILES_AND_DIRECTORIES
    end
    
    def action_bag(type, event)
      dialog.multi_selection_enabled = false
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
      return unless dialog.show_save_dialog(nil) == JFileChooser::APPROVE_OPTION
      
      bag_path = Context.local_path(dialog.selected_file.absolute_path)
      bag_data = files.map do |file|
        Context.local_path(file.absolute_path)
      end
      
      self.task = self.class.base_task + ['create', bag_path] + bag_data
      self.task.push "--version",                  @option1.selected_item
      self.task.push "--payloadmanifestalgorithm", @option2.selected_item
      self.task.push "--tagmanifestalgorithm",     @option3.selected_item
      self.task.push "--writer",                   @option4.selected_item
      execute
    end
  end
  
end
