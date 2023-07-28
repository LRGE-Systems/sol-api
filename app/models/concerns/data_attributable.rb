require 'json'

module DataAttributable
  extend ActiveSupport::Concern

  class_methods do
    def data_attr(*attrs)
      attrs.each do |attr|
        attr_as_string = attr.to_s
        define_method(attr) { 
          JSON.parse(data == "'{}'" ? "{}" : data)[attr_as_string] 
        }
        define_method("#{attr}=") { |val| 
          ld = JSON.parse(data == "'{}'" ? "{}" : data)
          ld[attr_as_string] = val
          self.data= JSON.generate(ld)
        }
      end
    end
  end
end
