# IMW.scripts.rb

# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– #

class Imw

    attr_accessor :img, :xsz, :ysz, :res

    def initialize(xsize = 0, ysize = 0)
        @img = Array.new(ysize) {Array.new(xsize) {[0, 0, 0, 0]}}
        @xsz = xsize
        @ysz = ysize
        @res = 1
    end

    def doc
        puts ""
        print   " IMW class.\n
                  | .img -> image array
                  | .xsz -> image width
                  | .ysz -> image height
                  | .res -> image resolution
                "
        puts ""
        return self
    end

    def crop(xsize = self.xsz, ysize = self.ysz)
        # Asserts
        if (xsize == self.xsz and ysize = self.ysz) or (xsize < 0 or ysize < 0)
           return self 
        end
        # Variables
        __old_y = self.ysz
        __old_x = self.xsz
        __new_image = []
        # Croping Image
        ysize.times { |index|
                        __new_image.append([])
                        xsize.times { |pixel|
                                        if (index +1) <= __old_y
                                            if (pixel +1) <= __old_x
                                                __new_image[index].append(self.img[index][pixel])
                                            else
                                                __new_image[index].append(Array.new(4, 0))
                                            end
                                        else
                                            __new_image[index].append(Array.new(4, 0))
                                        end
                                    }
                    }
        # Saving Data
        self.img = __new_image
        self.xsz = xsize
        self.ysz = ysize
        return self
    end
end

class Color

    attr_accessor :cn, :cl, :types

    def initialize(value = 0)
        @cl = value
        @cn = 'dec'
        @types = ['rgba', 'dec']
    end

    def doc
        puts ""
        print   " Color class.\n
                  | .cn    -> current format
                  | .cl    -> current color code
                  | .types -> possible formats
                "
        puts ""
        return self
    end

    def convert(to = 'rgba')
        # Asserts
        if not self.types.include?(to)
            return self
        end
        # Variables
        __cn = self.cn
        if __cn == 'rgba'
            __as = ((((self.cl[3]) * 256 + self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2])
        elsif __cn == 'dec'
            __as_c = self.cl
            # Alpha
            __as_a = (255 - (__as_c / 16777216)).floor()
            __as_c -= (255 - __as_a) * 16777216
            # Canals
            __as_r = (__as_c / 65536).floor()
            __as_c -= 65536 * __as_r
            __as_g = (__as_c / 256).floor()
            __as_c -= 256 * __as_g
            __as_b = (__as_c).floor()
            __as = [__as_r, __as_g, __as_b, __as_a]
        end
        # Savind Data
        self.cn = to
        self.cl = __as
        return self
    end
end
