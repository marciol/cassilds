class CassandraClient

  # A bunch of crap, mostly related to introspecting on column types
  module Helper
  
    private
    
    def is_super(column_family)
      @is_super[column_family] ||= column_family_property(column_family, 'Type') == "Super"
    end
    
    def column_name_class(column_family)
      @column_name_class[column_family] ||= column_name_class_for_key(column_family, "CompareWith")
    end
    
    def sub_column_name_class(column_family)
      @sub_column_name_class[column_family] ||= column_name_class_for_key(column_family, "CompareSubcolumnsWith")
    end
    
    def column_name_class_for_key(column_family, comparator_key)
      property = column_family_property(column_family, comparator_key)
      property =~ /.*\.(.*?)Type/
      self.class.const_get($1) # Long, UUID
    rescue NameError      
      String # UTF8, Ascii, Bytes, anything else
    rescue TypeError
      nil # Called sub_column_name_class on a standard column family
    end

    def column_family_property(column_family, key)
      @schema[column_family][key]
    rescue NoMethodError
      raise AccessError, "Invalid column family \":#{column_family}\""    
    end
    
    def columns_to_hash(column_family, columns)
      columns_to_hash_for_classes(columns, column_name_class(column_family), sub_column_name_class(column_family))
    end
    
    def sub_columns_to_hash(column_family, columns)
      columns_to_hash_for_classes(columns, sub_column_name_class(column_family))
    end
    
    def columns_to_hash_for_classes(columns, column_name_class, sub_column_name_class = nil)
      hash = OrderedHash.new
      Array(columns).each do |c|
        hash[column_name_class.new(c.name)] = if c.is_a?(SuperColumn)
          # Pop the class stack, and recurse
          columns_to_hash(c.columns, sub_column_name_class)
        else
          load(c.value)
        end
      end
      hash    
    end
    
    def hash_to_columns(hash, timestamp)
      hash.map do |column, value|
        Column.new(:name => column.to_s, :value => dump(value), :timestamp => timestamp)
      end    
    end
    
    def hash_to_super_columns(hash, timestamp)
      hash.map do |super_column, columns|
        SuperColumn.new(:name => super_column.to_s, :columns => hash_to_columns(columns, timestamp))
      end
    end    
  end
end
