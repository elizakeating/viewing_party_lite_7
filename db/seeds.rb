# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# User.destroy_all

# User.create!(name: 'Noelle', email: 'Queen@aol.com')
# User.create!(name: 'Chris', email: 'muttonchops@yahoo.com')
# User.create!(name: 'Antoine', email: 'antoine@gmail.com')

# viewing_party_1 = ViewingParty.create!(duration: 120, day: "2021-08-01", view_time: "2021-08-01 19:00:00 UTC")

# user_viewing_partie_1 = UserViewingParty.create!(user_id: noelle.id, viewing_party_id: viewing_party_1.id)

# user_id_2 = UserViewingParty.create!(user_id: chris.id, viewing_party_id: viewing_party_1.id)

admin_user = User.create(name:"AdminGuy", email: "admin@admin.com", password: "password", role: 2)
admin_user = User.create(name:"Default guy", email: "default@admin.com", password: "password", role: 0)
admin_user = User.create(name:"Guy", email: "phil@admin.com", password: "password", role: 0)
admin_user = User.create(name:"Another Guy", email: "jeff@admin.com", password: "password", role: 0)