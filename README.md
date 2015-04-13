# Example config

```yaml
api_key: key
api_secret: secret
user_id: 1
```

# Usage

`ruby wishlist.rb > books.csv`

# CSV Toolkit snippet

`csvcut -c title,num_pages,average_rating,owned books.csv | csvgrep -c owned -m 1 | csvsort -c num_pages | csvlook`
