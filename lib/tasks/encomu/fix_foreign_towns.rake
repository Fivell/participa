namespace :encomu do
  desc "[encomu] Sets towns for foreign registrations to empty"
  task :fix_foreign_towns => :environment do
    User.where.not(country: "ES").update_all(town: "")
  end
end
