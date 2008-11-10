require 'minitest/unit'
require 'minitest/mock'
require 'test/unit'

HTML_DIR = File.expand_path(File.dirname(__FILE__) + "/fixtures/html")

class ObjectStub
  attr_reader :return_value

  def initialize(return_value)
    @return_value = return_value
  end
end

class Object
  def stub!(name, return_value = nil)
    stub = ObjectStub.new(return_value)
    metaclass.__send__(:define_method, name) { |*args| stub.return_value }
  end

  def unstub!(name)
    metaclass.__send__(:remove_method, name)
  end

  def metaclass
    class << self; self; end
  end
end

$:.unshift(File.dirname(__FILE__) + "/../lib")
require 'fantasy'
