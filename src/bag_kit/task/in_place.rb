class BagKit
  
  class Task::InPlace < Task
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
      @option4 = JCheckBox.new "Retain enclosing folder"
      super(*args) do |c, i|
        c.option1_label = JLabel.new "Bagit version:"
        c.option1 = @option1
        c.option2_label = JLabel.new "Payload manifest algorithm:"
        c.option2 = @option2
        c.option3_label = JLabel.new "Tag manifest algorithm:"
        c.option3 = @option3
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
       [<option4         ]
       [(500,250)*files  ]
       [(500,250)*console]"
    end
    
    def text_window
      "Create bags in place"
    end
    
    def text_button_add
      "Add folders"
    end
    
    def list_label
      "Folders"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.map do |folder|
        t = self.class.base_task + ['baginplace', Context.local_path(folder.absolute_path)]
        t.push "--version",                  @option1.selected_item
        t.push "--payloadmanifestalgorithm", @option2.selected_item
        t.push "--tagmanifestalgorithm",     @option3.selected_item
        t.push "--retainbasedir" if @option4.is_selected
        t
      end
      execute
    end
  end
  
end
