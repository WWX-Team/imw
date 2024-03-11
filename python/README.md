# Documentation
~ **python edition** ~ v0

## Documentation

### Classes

#### imw

Represent an `imw` image.
```python
imw(
     xsize : int = "image width"
     ysize : int = "image height"
   ) # -> create an imw object

imw.vars
#  .img -> image file
#  .res -> image resolution
#  .xsz -> image width
#  .yzs -> image height

imw.methods
#  .crop   -> crop an imw object
#  .pack   -> pack an imw object and return a imw file str
#  .unpack -> open an imw file into an imw object

```

#### color

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
