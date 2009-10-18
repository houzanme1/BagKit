require 'profligacy/swing'
require 'profligacy/lel'

class BagKit
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  
  def initialize
    layout = "
      [ <tools          ]
      [ (500,400)*files ]
    "
    
    @files = List.new
    @table = JTable.new(@files)
    @table.intercell_spacing = Dimension.new(4,0)
    @table.row_height = 24
    
    @open_dialog = JFileChooser.new
    @open_dialog.multi_selection_enabled = true
    @open_dialog.file_selection_mode     = JFileChooser::FILES_AND_DIRECTORIES
    @open_dialog.dialog_title            = "Add Files"
    
    @save_dialog = JFileChooser.new
    @save_dialog.multi_selection_enabled = false
    @save_dialog.file_selection_mode     = JFileChooser::DIRECTORIES_ONLY
    @save_dialog.dialog_title            = "Bagit"
    
    @ui = Swing::LEL.new(JFrame, layout) do |c,i|
      c.files = JScrollPane.new(@table)
      c.tools = build_toolbar
    end
    @frame = @ui.build(:args => 'BagKit') do |f|
      f.default_close_operation = JFrame::EXIT_ON_CLOSE
      f.jmenu_bar = build_menu
    end
  end
  
  private
  
  def build_menu
    file_menu = Swing::Build.new(JMenu, :quit) do |c,i|
      c.quit = JMenuItem.new('Quit')
      i.quit = { :action => proc { |t,e| java.lang.System.exit(0) } }
    end.build('File')
    
    Swing::Build.new(JMenuBar, :menus) do |c,i|
      c.menus = [file_menu]
    end.build
  end
  
  def build_toolbar_button(label)
    btn = JButton.new(label)
    btn.margin = Insets.new(4,4,4,4)
    btn
  end
  
  def build_toolbar
    @toolbar = Swing::Build.new(JToolBar, :add, :clear, :bag) do |c,i|
      c.add    = build_toolbar_button "Add Files"
      c.clear  = build_toolbar_button "Remove All"
      c.bag    = build_toolbar_button "Bagit"
      
      i.add    = { :action => method(:action_add) }
      i.clear  = { :action => proc { |t,e| @files.clear } }
      i.bag    = { :action => method(:action_bag) }
    end
    @toolbar.build("Tools") do |t|
      t.floatable = false
    end
  end
  
  def action_add(type, event)
    return unless @open_dialog.show_open_dialog(nil) == JFileChooser::APPROVE_OPTION
    @files.add(*@open_dialog.selected_files)
  end
  
  def action_bag(type, event)
    return unless @save_dialog.show_save_dialog(nil) == JFileChooser::APPROVE_OPTION
    
    bag_path = Context.local_path(@save_dialog.selected_file.absolute_path)
    bag_data = @files.all.map do |file|
      Context.local_path(file.absolute_path)
    end
    
    task = Task.new('create', bag_path, *bag_data)
    task.execute
  end
  
  def check(text, &block)
    block.call || JOptionPane.show_message_dialog(nil, text, "Error", JOptionPane::DEFAULT_OPTION)
  end
end
