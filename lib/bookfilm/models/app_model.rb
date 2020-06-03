AppModel = Class.new(Sequel::Model)

class AppModel
  def stringify_keys
    values.stringify_keys
  end
end
