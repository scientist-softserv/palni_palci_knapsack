class AddWorkAuthorizations < ActiveRecord::Migration[5.2]
  def change
    create_table "work_authorizations", force: :cascade do |t|
      t.string   "work_title"
      t.belongs_to "user"
      t.datetime "expires_at", index: true
      t.string   "work_pid", index: true, null: false
      t.string  "scope"
      t.string   "error", default: nil
      t.timestamps
    end
  end
end
