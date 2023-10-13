class AddHostToUserViewingParties < ActiveRecord::Migration[7.0]
  def change
    add_column :user_viewing_parties, :host, :boolean
  end
end
