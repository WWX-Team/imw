# Documentation
~ **ruby edition** ~ v0.2

*Please notice that **ruby edition** is updated after python edition, for every RELEASE only.* *Some features may be missing.*

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
      xsize : int = "image width",
      ysize : int = "image height"
        )
# Crop the image and return/save the result

var.pack(
        )
# Return the .imw savecode of the current imw object

var.unpack(
      code : Imw.pack()
        )
# Update an imw with a .imw savecode

```

⚠️ | **Notice** | IMW object use Color(type = 'rgba') object for pixels

#### color

Represent a numeric color.

```ruby
var = Color.new
# Create a new Color object
# var.    | attr_accessor
#    .cn    -> color format
#    .cl    -> color code
#    .types -> possible color format

# METHODS

var.doc

var.convert(
         to : :types = "color format"
           )
# Convert a color format to an other
```

⚠️ | **Notice** | `rgba` format is highly RECOMMANDED for use

----
### How to use

```ruby
require_relative 'path/scripts'
```

ℹ️ | **Info** | If not working, you will need to add the extension (`.rb`) add the end of the file name
