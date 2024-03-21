# IMW.scripts.rb

# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– #

class Imw

    attr_accessor :img, :xsz, :ysz, :res

    def initialize(xsize = 0, ysize = 0)
        @img = Array.new(ysize) {Array.new (xsize){Color.new(cn = 'rgba', value = [0, 0, 0, 0])}}
        @xsz = xsize
        @ysz = ysize
        @res = 1
    end

    def doc
        puts ""
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts " Class   |                         IMW class (Imw)                          |"
        puts "         | –– Symbols ––                                                    |"
        puts "         | .img -> image array                                              |"
        puts "         | .xsz -> image width                                              |"
        puts "         | .ysz -> image height                                             |"
        puts "         | .res -> image resolution                                         |"
        puts "         | –– Methods ––                                                    |"
        puts "         | .new(xsize : int, ysize : int)  -> create a new imw              |"
        puts "         | .crop(xsize : int, ysize : int) -> crop an imw                   |"
        puts "         | .pack()                         -> pack an imw into its savecode |"
        puts "         | .unpack(code : imw.pack())      -> update an imw with a savecode |"  
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
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
                                        if (index +1) <= __old_y and (pixel +1) <= __old_x
                                                __new_image[index].append(self.img[index][pixel])
                                        else
                                            __new_image[index].append(Color.new(cn = 'rgba', value = [0, 0, 0, 0]))
                                        end
                                    }
                    }
        # Saving Data
        self.img = __new_image
        self.xsz = xsize
        self.ysz = ysize
        return self
    end

    def to_str()
        return self.pack
    end

    def pack()
        packed =  ""
        packed += self.res.to_s + "\\"
        packed += self.ysz.to_s + "@"
        self.ysz.times  { |index|
                            self.xsz.times  { |pixel|
                                                packed << self.img[index][pixel].convert(to = 'dec').cl.to_s + "/"
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
                    __color = Color.new(cn = 'dec', value = __data.to_i)
                    __color.convert(to = 'rgba')
                    __line.append(__color)
                end
                __data = ''
            else
                __data << code[idx]
            end
            idx += 1
        end
        # Croping Image
        __img.each_with_index   { |el, line|
                        if __img[line].length != __img_xsz
                            __line_len = __img[line].length.to_f
                            __img[line].each    { |line|
                                                    ((__img_xsz - __line_len) / 2 - 0.4).round.times  { 
                                                                                                        __img[line].insert(0, Color.new(cn = 'rgba', value = [0, 0, 0, 0]))
                                                                                                    }
                                                    ((__img_xsz - __line_len) / 2 + 0.4).round.times  {
                                                                                                        __img[line].append(Color.new(cn = 'rgba', value = [0, 0, 0, 0]))
                                                                                                    }
                                                }
                        end
                                }
        # Building Image
        self.img = __img
        self.ysz = __img_ysz
        self.xsz = __img_xsz
        self.res = __img_res
        return self
    end
end

class Color

    attr_accessor :cn, :cl, :types

    def initialize(cn = 'dec', value = 0)
        @cl = value
        @cn = cn
        @types = ['rgba', 'dec']
    end

    def doc
        puts ""
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
        puts " Class   |                            Color class                           |"
        puts "         | –– Symbols ––                                                    |"
        puts "         | .cn    -> image array                                            |"
        puts "         | .cl    -> image width                                            |"
        puts "         | .types -> image height                                           |"
        puts "         | –– Methods ––                                                    |"
        puts "         | .new(cn : Color.types, value : custom)  -> create a new object   |"
        puts "         | .convert(to : Color.types) -> convert a color to an other format |"
        puts "–––––––––+––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––+"
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
            __as = ((((255 - self.cl[3]) * 256 + self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2])
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
