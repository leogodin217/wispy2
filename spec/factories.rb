FactoryGirl.define do
  factory :front do
    sequence(:market)      { |n| "Market #{n}" }
    sequence(:segment)     { |n| "Segment #{n}" }
    sequence(:site)        { |n| "Site #{n}" }
    sequence(:app_layer)   { |n| "App layer #{n}" }
    sequence(:pipe)        { |n| "Pipe #{n}" }
    sequence(:status)      { |n| "Status #{n}" }
    sequence(:notes)       { |n| "Notes #{n}" }
  end
end

