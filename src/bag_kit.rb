require 'profligacy/swing'
require 'profligacy/lel'

class BagKit
  include_package 'javax.swing'
  include_package 'java.awt'
  include Profligacy
  
  def self.build_toolbar_button(label)
    btn = JButton.new(label)
    btn.margin = Insets.new(4,4,4,4)
    btn
  end
  
  def initialize
    @ui = Swing::LEL.new(JFrame, "[toolbar]") do |c,i|
      c.toolbar = build_toolbar
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
  
  def build_toolbar
    @toolbar = Swing::Build.new(JToolBar, :task_create,
                                          :task_in_place,
                                          :task_update,
                                          :task_validate) do |c,i|
      c.task_create   = BagKit.build_toolbar_button "Create a bag"
      c.task_in_place = BagKit.build_toolbar_button "Create bags in place"
      c.task_update   = BagKit.build_toolbar_button "Update bags"
      c.task_validate = BagKit.build_toolbar_button "Validate bags"
      
      i.task_create   = { :action => Task::Create.method(:new) }
      i.task_in_place = { :action => Task::InPlace.method(:new) }
      i.task_update   = { :action => Task::Update.method(:new) }
      i.task_validate = { :action => Task::Validate.method(:new) }
    end
    @toolbar.build("Toolbar") do |t|
      t.floatable = false
    end
  end
end
