class TeamSerializer
  include JSONAPI::Serializer
  attributes :name, :seed, :region, :actual_conference
end
