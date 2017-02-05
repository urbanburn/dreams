ActiveAdmin.register Camp do
  EXCLUDED = %w(contact_email user_id seeking_members safetybag_firstMemberName safetybag_firstMemberEmail safetybag_secondMemberName safetybag_secondMemberEmail)

  scope :displayed, default: true

  index do
    selectable_column

    (Camp.column_names - EXCLUDED).each do |cn|
      column I18n.t("activerecord.attributes.camp.#{cn}"), cn
    end
    column :manager_name
    column :manager_email
    column :manager_phone
  end

  member_action :show do
      @camp = Camp.includes(versions: :item).find(params[:id])
      @versions = @camp.versions 
      @camp = @camp.versions[params[:version].to_i].reify if params[:version]
      show!
  end

  member_action :history do
    @camp = Camp.find(params[:id])
    @versions = PaperTrail::Version.where(item_type: 'Camp', item_id: @camp.id)
    render "layouts/history"
  end

  sidebar :versionate, :partial => "layouts/version", :only => :show

  permit_params do |params|
    Camp.columns.map(&:name) - %w(id updated_at created_at)
  end
end
