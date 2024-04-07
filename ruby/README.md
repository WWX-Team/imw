# Documentation
~ **ruby edition** ~ v0.2.2

## Documentation

### Classes

#### imw

Represent an `imw` image.

```ruby
var = Imw.new(xsize = 'width', ysize = 'height')
# Create a new Imw object
# var.    | attr_accessor
#    .img -> image array
#    .res -> image resolution
#    .xsz -> image width
#    .ysz -> image height

# METHODS

var.doc

var.crop(
      xsize : Integer = "image width",
      ysize : Integer = "image height"
        )
# Crop the image and return/save the result

var.pack
# Return the .imw savecode of the current imw object

var.unpack(
      code : Imw.pack()
        )
# Update an imw with a .imw savecode

var.edit(
      x       : Integer,
      y       : Integer,
      color   : Color
        )
# Update an image's pixel with Color class

#to_i, to_a, #to_s
```

⚠️ | **Notice** | IMW object use Color class for pixels

#### color

Represent a numeric color.

```ruby
var = Color.new
# Create a new Color object
# var.    | attr_accessor
#    .cl    -> color code
# METHODS

var.doc

var.rgba(
      from : Integer
        )
# convert an int into a 4-int rgba color code |!| do not update self.cl

var.edit(
      array : Array
        )
# update a color with an array (and check if array is corect)

var.channel(
      which : String ('r' or 'g' or 'b' or 'a'),
      value : Integer 0 ≤ x ≤ 255
           )
# update a color's channel

#to_i, to_a
#is_valid?(array)
```

----
### How to use

```ruby
require_relative 'path/scripts'
```

ℹ️ | **Info** | If not working, you will need to add the extension (`.rb`) add the end of the file name
