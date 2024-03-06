class LeagueSerializer
  include JSONAPI::Serializer
  attributes :name, :manager_id, :draft_status, :draft_date_time
end
