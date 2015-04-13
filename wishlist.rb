require 'yaml'
require 'json'
require 'csv'
require 'active_support'
require 'goodreads'

config = YAML::load_file(File.join(__dir__, 'config.yml'))

client = Goodreads.new(api_key: config["api_key"], api_secret: config["api_secret"])

def parse_books(books)
  books.map do |entry|
    book = entry.book

    {
      id: book.id,
      title: book.title,
      author: book.authors.author.name,
      num_pages: book.num_pages,
      image_url: book.image_url,
      url: book.link,
      average_rating: book.average_rating,
      owned: entry.owned.to_i,
    }
  end
end

def get_books_from_shelf(client, user_id, shelf)
  books = []
  response = client.shelf(user_id, shelf)
  pages = response.total / 100.0
  (1..pages.ceil).each do |p|
    books << parse_books(client.shelf(user_id, shelf, per_page: 100, page: p).books)
  end

  books.flatten
end

to_read = get_books_from_shelf(client, config["user_id"], "to-read")

csv_string = CSV.generate do |csv|
  csv << to_read.first.keys

  to_read.each do |row|
    csv << row.values
  end
end

puts csv_string
