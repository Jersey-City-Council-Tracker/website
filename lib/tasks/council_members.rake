namespace :council_members do
  desc "Seed the 2026 Jersey City council members"
  task seed_2026: :environment do
    members = [
      { first_name: "Denise", last_name: "Ridley", seat: :ward_a },
      { first_name: "Joel A.", last_name: "Brooks", seat: :ward_b },
      { first_name: "Thomas", last_name: "Zuppa Jr.", seat: :ward_c },
      { first_name: "Jake", last_name: "Ephros", seat: :ward_d },
      { first_name: "Eleana", last_name: "Little", seat: :ward_e },
      { first_name: "Frank E.", last_name: "Gilmore", seat: :ward_f },
      { first_name: "Mamta", last_name: "Singh", seat: :at_large },
      { first_name: "Michael O.", last_name: "Griffin", seat: :at_large },
      { first_name: "Rolando R.", last_name: "Lavarro Jr.", seat: :at_large }
    ]

    term_start = Date.new(2026, 1, 15)
    created = 0
    skipped = 0

    members.each do |attrs|
      if CouncilMember.where(last_name: attrs[:last_name], seat: attrs[:seat], term_end: nil).exists?
        puts "  skip  #{attrs[:first_name]} #{attrs[:last_name]} (already exists)"
        skipped += 1
      else
        CouncilMember.create!(attrs.merge(term_start: term_start))
        puts "  add   #{attrs[:first_name]} #{attrs[:last_name]} (#{attrs[:seat]})"
        created += 1
      end
    end

    puts ""
    puts "Done. #{created} added, #{skipped} skipped."
  end
end
