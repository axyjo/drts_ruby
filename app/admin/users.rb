ActiveAdmin.register User do
  scope :unassociated

  index do
    column :id
    column :username
    column :email
    column :empire
    column "Last Login Time", :current_sign_in_at
    column :created_at
    default_actions
  end

  form do |f|
    f.inputs "User Details" do
      f.input :username
      f.input :email
      f.input :empire
    end
    f.buttons
  end
end
