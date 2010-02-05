class BagKit
  
  class Task::Create < Task
    include ListLayout
    
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
      bag_data = files.all.map do |file|
        Context.local_path(file.absolute_path)
      end
      
      self.task = self.class.base_task + ['create', bag_path] + bag_data
      execute
    end
  end
  
end
