class Artist < Struct.new(:real_name, :primary_alias)
  include Model

  attr_accessor :real_name, :primary_alias

  has_many :releases

  validates_presence_of :real_name, :primary_alias

end