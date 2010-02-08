class BagKit
  
  class Task::Update < Task
    include_package 'javax.swing'
    include_package 'javax.swing.border'
    include_package 'javax.swing.text'
    include_package 'java.awt'
    include ListLayout
    
    def initialize(*args)
      @option1 = JComboBox.new ["filesystem", "tar", "tar_gz", "tar_bz2", "zip"].to_java(:String)
      super(*args) do |c, i|
        c.option1_label = JLabel.new "Write to:"
        c.option1 = @option1
      end
    end
    
    def layout
      "[<toolbar         ]
       [<option1_label   ]
       [<option1         ]
       [(500,250)*files  ]
       [(500,250)*console]"
    end
    
    def text_window
      "Update bags"
    end
    
    def text_button_add
      "Add bags"
    end
    
    def list_label
      "Bags"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.map do |folder|
        self.class.base_task + [
          'update', Context.local_path(folder.absolute_path), "--writer", @option1.selected_item
        ]
      end
      execute
    end
  end
  
end
