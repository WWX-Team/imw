# IMW.scripts.rb

# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– #

class Imw

    attr_accessor :img, :xsz, :ysz, :res

    def initialize(xsize = 0, ysize = 0)
        @img = Array.new(ysize) {Array.new (xsize){Color.new()}}
        @xsz = xsize
        @ysz = ysize
        @res = 1
    end

    def doc
        puts ""
        puts "–––––––––+–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts " Class   |                         IMW class (Imw)                                 |"
        puts "         | –– Symbols ––                                                           |"
        puts "         | .img                                   -> image array                   |"
        puts "         | .xsz                                   -> image width                   |"
        puts "         | .ysz                                   -> image height                  |"
        puts "         | .res                                   -> image resolution              |"
        puts "         | –– Methods ––                                                           |"
        puts "         | .new(xsize : int, ysize : int)         -> create a new imw              |"
        puts "         | .crop(xsize : int, ysize : int)        -> crop an imw                   |"
        puts "         | .pack()                                -> pack an imw into its savecode |"
        puts "         | .unpack(code : imw.pack())             -> update an imw with a savecode |"  
        puts "         | .edit(x : int, y : int, color : Color) -> edit the a pixel's color      |"
        puts "         | –– Converts ––                                                          |"
        puts "         | to_s, to_a, to_i                                                        |"
        puts "–––––––––+–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts ""
        return self
    end

    def to_s
        return self.pack
    end

    def to_a
        return self.img
    end

    def to_i
        return self.xsz * self.ysz
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
                                        if (index +1) <= __old_y and (pixel +1) <= __old_x and (pixel +1) < __new_image[index].length
                                                __new_image[index].append(self.img[index][pixel])
                                        else
                                            __new_image[index].append(Color.new())
                                        end
                                    }
                    }
        # Saving Data
        self.img = __new_image
        self.xsz = xsize
        self.ysz = ysize
        return self
    end

    def pack
        packed =  ""
        packed += self.res.to_s + "\\"
        packed += self.ysz.to_s + "@"
        self.ysz.times  { |index|
                            self.xsz.times  { |pixel|
                                                packed << self.img[index][pixel].to_i.to_s + "/"
                                            }
                            packed << "#/"
                        }
        packed << "◊Created with IMW-RUBY◊"
        return packed
    end

    def unpack(code)
        if code.class != String
            return self
        end
        __needed = ['\\', '@', '/', '#', '◊']
        #__needed.each { |n|
        #    if code.include?(n)
        #        return self
        #    end
        #              }
        __img_res = 0
        __img_ysz = 0
        __img_xsz = 0
        __img = []
        idx = 0
        while code[idx] != '\\' and idx <= code.length
            __img_res = code[0..idx].to_f
            idx += 1
        end
        if __img_res.to_i == __img_res then __img_res = __img_res.to_i end
        idx += 1
        idx_saved = idx
        while code[idx] != '@' and idx <= code.length
            __img_ysz = code[idx_saved..idx].to_i
            idx += 1
        end
        idx += 1
        idx_saved = idx
        __data = ''
        __line = []
        __lenX = 0
        while code[idx] != '◊' and idx <= code.length
            if code[idx]  == '/'
                if __data == '#'
                    __img.append(__line)
                    if __lenX > __img_xsz then __img_xsz = __lenX end
                    __line = []
                    __lenX = 0
                else
                    __lenX += 1
                    __color = Color.new()
                    __color.edit(rgba(__data.to_i))
                    __line.append(__color)
                end
                __data = ''
            else
                __data << code[idx]
            end
            idx += 1
        end
        # Building Image
        self.img = __img
        self.ysz = __img_ysz
        self.xsz = __img_xsz
        self.res = __img_res
        return self.crop()
    end

    def edit(x = 0, y = 0, color = Color.new())
        if not (x < self.xsz and y < self.ysz) then return self end
        if not color.instance_of?(Color)           then return self end
        self.img[x][y] = color
        return self
    end

end

class Color

    attr_accessor :cl

    def initialize(value = [0, 0, 0, 255])
        if self.is_valid?(value) then asvalue = value
        else                          asvalue = [0, 0, 0, 255] end
        @cl = asvalue
    end

    def doc
        puts ""
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts " Class   |                            Color class                         |"
        puts "         | –– Symbols ––                                                  |"
        puts "         | .cl                          -> rgba array                     |"
        puts "         | –– Methods ––                                                  |"
        puts "         | .new(value   : Array(0, 4))  -> create a new object            |"
        puts "         | .decimal                     -> output color int code          |"
        puts "         | .rgba(from)                  -> output rgba tab from int code  |"
        puts "         | .edit(array)                 -> update obj with array          |"
        puts "         | .channel(which, value)       -> update rgba channel with value |"
        puts "         | –– Converts ––                                                 |"
        puts "         | to_a, to_i                                                     |"
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts ""
        return self
    end

    def is_valid?(from)
        if not from.instance_of?(Array) then return false end
        from.each { |n|
                        if not n.instance_of?(Integer) then return false end
                  }
        return true
    end

    def to_i
        return self.decimal
    end

    def to_a
        return self.cl
    end

    def decimal()
        return (((255 - self.cl[3]) * 256 + self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2]
    end

    def rgba(from)
        order  = [3,0,1,2]
        asint  = from
        asdef  = [0, 0, 0, 255]
        asrgba = [0, 0, 0, 255]
        4.times { |idx|
                    asrgba[order[idx]] = (asdef[order[idx]] - asint / (256 ** (3 - idx))) .floor .abs
                    asint              = asint - ((asdef[order[idx]] - asrgba[order[idx]]).abs * (256 ** (3 - idx)))
                }
        return asrgba
    end

    def edit(array)
        if self.is_valid?(array) then self.cl = array end
        return self
    end

    def channel(which, value)
        channels = ['r', 'g', 'b', 'a']
        if channels.include?(which) and (value >= 0 and value <= 255)
            self.cl[channels.index(which)] = value end
        return self
    end
end
