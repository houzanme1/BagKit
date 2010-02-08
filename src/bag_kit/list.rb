class BagKit
  
  class List < javax.swing.table.AbstractTableModel
    include Enumerable
    
    attr_accessor :label
    
    def initialize(*list)
      @label = 'Files'
      @files = list
      super()
    end
    
    def each(&block)
      @files.each(&block)
    end
    
    def all
      to_a
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
      if column == 0
        @label
      end
    end
    
    def getValueAt(row, column)
      if column == 0
        @files[row].absolute_path
      end
    end
    
    def getColumnClass(column)
      if column == 0
        java.lang.String
      end
    end
  end
  
end
