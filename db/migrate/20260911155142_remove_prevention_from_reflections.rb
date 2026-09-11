class RemovePreventionFromReflections < ActiveRecord::Migration[7.1]
  def change
    remove_column :reflections, :prevention, :text
  end
end
