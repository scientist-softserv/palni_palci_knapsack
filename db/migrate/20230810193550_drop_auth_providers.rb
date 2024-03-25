class DropAuthProviders < ActiveRecord::Migration[5.2]
  def change
    drop_table :auth_providers do |t|
      t.string "provider"
      t.integer "account_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "oidc_client_id"
      t.string "saml_client_id"
      t.string "oidc_client_secret"
      t.string "saml_client_secret"
      t.string "oidc_idp_sso_service_url"
      t.string "saml_idp_sso_service_url"
    end
  end
end
