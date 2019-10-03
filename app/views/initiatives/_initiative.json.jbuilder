json.extract! initiative, :id, :name, :summary, :image_url, :anticipated_carbon_saving, :locality, :location, :alternative_solution_name, :lead_group_id, :contact_name, :contact_email, :contact_phone, :partner_groups_role, :status_id, :gdpr, :gdpr_email_verified, :created_at, :updated_at
json.url initiative_url(initiative, format: :json)
