class BagKit
  
  class Task::Update < Task
    include ListLayout
    
    def text_window
      "Update bags"
    end
    
    def text_button_add
      "Add bags"
    end
    
    def before_action_add
      dialog.multi_selection_enabled = true
      dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    end
    
    def action_bag(type, event)
      self.task = files.map do |folder|
        self.class.base_task + ['update', Context.local_path(folder.absolute_path)]
      end
      execute
    end
  end
  
end
