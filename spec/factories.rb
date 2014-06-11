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

  factory :market do
    sequence(:market) { |n| "Market #{n}" }
    active true
  end

  factory :segment do
    sequence(:segment) { |n| "Segment #{n}" }
    active true
  end

  factory :site do
    sequence(:site) { |n| "Site #{n}" }
    active true
  end

  factory :app_layer do
    sequence(:app_layer) { |n| "App layer #{n}" }
    active true
  end

  factory :pipe do
    sequence(:pipe) { |n| "Pipe #{n}" }
    active true
  end

  factory :status do
    sequence(:status) { |n| "Status #{n}" }
    active true
  end

end

