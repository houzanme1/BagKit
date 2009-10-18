class BagKit
  
  class List < javax.swing.table.AbstractTableModel
    def initialize(*list)
      @files = list
      super()
    end
    
    def all
      Array.new(@files)
    end
    
    def add(*list)
      @files.concat(list)
      fire_table_data_changed
    end
    
    def clear
      @files.clear
      fire_table_data_changed
    end
    
    def getColumnCount
      1
    end
    
    def getRowCount
      @files.size
    end
    
    def getColumnName(column)
      case column
      when 0 then 'Files'
      end
    end
    
    def getValueAt(row, column)
      case column
      when 0 then @files[row].absolute_path
      end
    end
    
    def getColumnClass(column)
      case column
      when 0 then java.lang.String
      end
    end
  end
  
end
