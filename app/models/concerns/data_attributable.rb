module DataAttributable
  extend ActiveSupport::Concern

  class_methods do
    def data_attr(*attrs)
      attrs.each do |attr|
        attr_as_string = attr.to_s
        puts "AAAAAAAAAAAAAAAAAAAAAAAAAA"
        puts "SEEEE THIS"
        puts attr 
        puts attr_as_string
        if attr_as_string != "[]"
          define_method(attr) { data[attr_as_string] }
          define_method("#{attr}=") { |val| data[attr_as_string] = val }
        end
      end
    end
  end
end
