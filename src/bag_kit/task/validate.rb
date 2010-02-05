class BagKit
  
  class Task::Validate < Task
    include ListLayout
    
    def initialize(t, e)
      self.auto_close = false
      super
    end
    
    def text_window
      "Validate bags"
    end
    
    def text_button_add
      "Add bags"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.all.map do |folder|
        self.class.base_task + ['verifyvalid', Context.local_path(folder.absolute_path)]
      end
      execute
    end
  end
  
end
