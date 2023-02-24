# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Movie.destroy_all

# Set your API key
require 'themoviedb-api'

# Configure API key
Tmdb::Api.key("6eb494efafc64253e091e259bedaece6")

# Set language to English (en)
Tmdb::Api.language("en")

# Fetch 10 popular movies from the API
movies = Tmdb::Movie.popular(page: 1).results

# Create a `Movie` record for each movie
movies.each do |movie|
  poster_path = movie.poster_path
  poster_url = "https://image.tmdb.org/t/p/w500/#{poster_path}"
  Movie.create(title: movie.title, overview: movie.overview, poster_url: poster_url, rating: movie.rating)
end
