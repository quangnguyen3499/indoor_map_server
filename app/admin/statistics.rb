ActiveAdmin.register Statistic do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :floor_id, :place_id, :nodes
  #
  # or
  #
  # permit_params do
  #   permitted = [:floor_id, :place_id, :nodes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
