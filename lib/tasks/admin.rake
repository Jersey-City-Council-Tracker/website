namespace :admin do
  desc "Generate the initial site admin user"
  task generate_site_admin: :environment do
    if User.site_admin.exists?
      puts "A site admin already exists. Aborting."
      exit 1
    end

    email = ENV.fetch("ADMIN_EMAIL", "admin@counciltracker.org")
    name = ENV.fetch("ADMIN_NAME", "Site Admin")
    password = SecureRandom.alphanumeric(16)

    user = User.create!(
      name: name,
      email_address: email,
      password: password,
      password_confirmation: password,
      role: :site_admin
    )

    puts "Site admin created successfully!"
    puts "  Email:    #{user.email_address}"
    puts "  Password: #{password}"
    puts ""
    puts "Sign in at /session/new and change your password."
  end
end
