ActiveAdmin.register User do
  index do
    column :id
    column :username
    column :email
    column :empire
    column "Last Login Time", :current_sign_in_at
    column :created_at
    default_actions
  end
end
