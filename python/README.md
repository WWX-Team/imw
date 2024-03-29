# Documentation
~ **python edition** ~ v0.2

## Documentation

### Classes

#### Imw

Represent an `imw` image.

```python
Imw(
     xsize : int = 'image width'
     ysize : int = 'image height'
   ) # -> create an imw object
#    | ###.vars
#         .img -> image file
#         .res -> image resolution
#         .xsz -> image width
#         .yzs -> image height

###.methods
imw.crop()   # -> crop an imw object
#               | xsize : int = image width  => self.xsz
#               | ysize : int = image height => self.ysz

imw.pack()   # -> pack an imw object and return a imw file str

imw.unpack() # -> open an imw file into an imw object
#               | code : str = imw file

```

⚠️ | **Notice** | IMW object use Color(type = 'rgba') object for pixels

#### Color

Represent a numeric color.

```python
Color(
       dec : int = 'decimal color'
     ) # -> create a color object
#      | ###.vars
#           .cl    -> color code
#           .cn    -> color format
#           .types -> supported color format

###.methods
color.convert() # -> convert a color object to an other format
#                  | to : str = color format => 'rgba' | color.types
```

⚠️ | **Notice** | `rgba` format is highly RECOMMANDED for use

----
### How to use

#### As file

In your workspace, add `scripts.py` and rename it into `imw.py`.
Now, in your file(s), add :
```python
import imw
```

#### As a pip extension

*Not planned*.

----
