class BagKit
  
  class Task::InPlace < Task
    include ListLayout
    
    def text_window
      "Create bags in place"
    end
    
    def text_button_add
      "Add folders"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.all.map do |folder|
        self.class.base_task + ['baginplace', Context.local_path(folder.absolute_path)]
      end
      execute
    end
  end
  
end
