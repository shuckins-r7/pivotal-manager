require "factory_girl"

FactoryGirl.define do
  
  # Make an integer that looks sorta like a PivotalTracker ID
  sequence(:pt_id){ |n| rand(100000..450000) + n }

  # Sequences useful for feature stories
  sequence(:feature_name){|n| "Feature the #{n}th will be breathtaking"}
  sequence(:feature_description){|n| "Make the #{n}th happen with aplomb and NoSQL and Node."}
  

  factory :iteration do
    pt_id {FactoryGirl.generate(:pt_id)}

  end

  factory :member do
    pt_id {FactoryGirl.generate(:pt_id)}
    
    name "Grizzle McPorkchop"
    email "grizzle@porkchopswreckshop.com"
    role "Member"
    initials "GM"
  end

  factory :story do
    pt_id {FactoryGirl.generate(:pt_id)}

    story_type "feature"
    name {FactoryGirl.generate(:feature_name)}
    created_at 1.week.ago
    current_state "started"
    description {FactoryGirl.generate(:feature_description)}
    owned_by "Dudley Snazzypants"
    requested_by "Lord Product"
  end

end
