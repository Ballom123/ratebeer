class RemoveStyleDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :beers, :style_id, nil
  end
end
