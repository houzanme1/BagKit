class BagKit
  
  class Task::Validate < Task
    include_package 'javax.swing'
    include_package 'javax.swing.border'
    include_package 'javax.swing.text'
    include_package 'java.awt'
    include ListLayout
    
    def initialize(*args)
      self.auto_close = false
      
      @option1 = JCheckBox.new "Ignore missing bag-it.txt"
      @option2 = JCheckBox.new "Ignore additional folders"
      @option3 = JComboBox.new ["", "0.93", "0.94", "0.95", "0.96"].to_java(:String)
      super(*args) do |c, i|
        c.option1 = @option1
        c.option2 = @option2
        c.option3_label = JLabel.new "Bagit version:"
        c.option3 = @option3
      end
    end
    
    def layout
      "[<toolbar         ]
       [<option1         ]
       [<option2         ]
       [<option3_label   ]
       [<option3         ]
       [(500,250)*files  ]
       [(500,250)*console]"
    end
    
    def text_window
      "Validate bags"
    end
    
    def text_button_add
      "Add bags"
    end
    
    def text_button_bagit
      "Validate all"
    end
    
    def list_label
      'Bags'
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.map do |folder|
        t = self.class.base_task + ['verifyvalid', Context.local_path(folder.absolute_path)]
        t.push "--version", @option3.selected_item  if @option3.selected_index > 0
        t.push "--missingbagittolerant"             if @option1.is_selected
        t.push "--additionaldirectorytolerant"      if @option2.is_selected
        t
      end
      execute
    end
  end
  
end
