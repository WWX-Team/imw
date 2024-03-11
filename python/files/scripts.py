# IMW.scripts.py

# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– #

class imw:
    """
    IMW class :\n
    \xA0\xA0- .img -> image array      ;\n
    \xA0\xA0- .res -> image resolution ;\n
    \xA0\xA0- .ysz -> image height     ;\n
    \xA0\xA0- .xsz -> image width      ;\n
    """
    def __init__(self, ysize:int=0, xsize:int=0):
        self.img = [[[0, 0, 0, 0] for x in range(xsize)] for y in range(ysize)]
        self.res = 1
        self.ysz = ysize
        self.xsz = xsize
        
    def crop(self, xsize:int='', ysize:int='', clrwith:list=[0, 0, 0, 0]):
        """
        [IMW / Crop]: Add / Remove pixels to crop an IMW.\n
        \xA0\xA0- xsize (width)  ;\n
        \xA0\xA0- ysize (height) ;\n
        \xA0\xA0- clrwith (color) ;
        """
        xs = xsize
        if xs == '':
            xs = self.xsz
        ys = ysize
        if ys == '':
            ys = self.ysz
        if ys == self.ysz and xs == self.xsz: return self
        __repeat_x = xs
        if self.xsz > __repeat_x: __repeat_x = self.xsz
        __repeat_y = ys
        if self.ysz > __repeat_y: __repeat_y = self.ysz
        __file     = self.img
        __y_file   = []
        __new_file = []
        # Crop Y
        for stepy in range(__repeat_y):
            if stepy < ys:
                if stepy < self.ysz: __y_file.append(__file[stepy])
                else               :  __y_file.append([])
        # Crop X      
        for stepy in range(len(__y_file)):
            __new_file.append([])
            for stepx in range(__repeat_x):
                if stepx < xs:
                    if stepx < len(__y_file[stepy]): __new_file[stepy].append(__y_file[stepy][stepx])
                    else                           :
                        __new_file[stepy].append(clrwith)
        # Rebuild IMW
        self.img = __new_file
        self.xsz = __repeat_x
        self.ysz = __repeat_y
        return self
        
    def pack(self) -> str:
        """
        [IMW / Pack]: Pack an imw object into an imw file.
        \xA0\xA0! DON'T SAVE THE RESULT IN SELF IMW OBJECT ;\n
        """
        # Program
        __build = str(self.res) + '\\' + str(self.ysz) + '@'
        for line in self.img:
            __build_line = ''
            for pixel in line:
                __pixel = color()
                __pixel.convert(to = 'rgba')
                for i in range(len(pixel)):
                    __pixel.edit(target = color.canals[i], value = pixel[i])
                __pixel.convert(to = 'dec')
                __build_line += str(__pixel.cl) + '/'
            __build += __build_line + '#/'    
        return __build + '◊'
        
    def unpack(self, code:str):
        """
        [IMW / Unpack]: Unpack an imw file into an imw object.\n
        \xA0\xA0- code (file to load)  ;
        """
        for el in ['@', '\\', '/', '#', '◊']:
            if not el in code: return None
        idx = 0
        __len_code = len(code)
        __img = []
        __res = ''
        __ysz = 0
        # Res
        while code[idx] != '\\' or idx > __len_code:
            __res += code[idx]
            idx += 1
        __res = int(__res)
        if idx > __len_code: return None
        idx += 1
        # Y Size
        while code[idx] != '@' or idx > __len_code:
            __ysz = __ysz * 10 + int(code[idx])
            idx += 1
        if idx > __len_code: return None
        idx += 1
        # Image
        __max_x = 0
        # Create New Line
        __img_line = []
        __img_line_x = 0
        __img_pixel = ''
        while not code[idx] in ['◊', '¬'] or idx > __len_code:
            if code[idx] == '/':
                if __img_pixel  == '#':
                    __img.append(__img_line)
                    if __img_line_x > __max_x: __max_x = __img_line_x
                    # Create New Line
                    __img_line = []
                    __img_line_x = 0
                else:
                    __img_line.append(color(dec = int(__img_pixel)))
                    __img_line_x += 1
                __img_pixel = ''
            else:
                __img_pixel += code[idx]
            idx += 1
            
        if idx > __len_code: return None
            
        # Building Data
        for line in range(len(__img)):
            for pixel in range(len(__img[line])):
                __img[line][pixel] = __img[line][pixel].convert(to = 'rgba').cl
                
        # Uniformiser la taille X
        for line in range(len(__img)):
            if len(__img[line])  != __max_x:
                for el in range(round((__max_x - len(__img[line])) / 2 + -.4)):
                    __img[line].insert(0, [0, 0, 0, 0])
                for el in range(round((__max_x - len(__img[line])) / 2 + +.4)):
                    __img[line].append([0, 0, 0, 0])
                    
        self.img = __img
        self.res = __res
        self.xsz = __max_x
        self.ysz = __ysz
        
        return self
    
    #def edit(self, x, y)

class color:
    """
    Color class :\n
    \xA0\xA0- .types  -> working color formats [:list] ;\n
    \xA0\xA0- .cn     -> current color format  [:str]  ;\n
    \xA0\xA0- .cl     -> current color code    [:any]  ;\n
    """
    types  = ['scratch', 'dec', 'rgb', 'rgba', 'hex']
    canals = ['r', 'g', 'b', 'a']
        
    def __init__(self, dec:int=0):
        """
        [Color / Init]: [dec:int] represent a decimal scratch color
        """
        self.cn = 'dec'
        self.cl = dec
        
    def convert(self, to:str='dec'):
        if self.cn != to and to in self.types:
            # Get Color
            __color = 0
            if self.cn in ['dec', 'scratch']:
                __color = self.cl
            elif self.cn in ['rgb']:
                __color = ((self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2]
            elif self.cn in ['rgba']:
                __color = (((self.cl[3]) * 256 + self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2]
            elif self.cn in ['hex']:
                __color = (int('0x' + self.cl[0:2], 16) * 256 + int('0x' + self.cl[2:4], 16)) * 256 + int('0x' + self.cl[4:6], 16)
                if len(self.cl) == 8: __color += (255 - int('0x' + self.cl[6:8], 16)) * 16777216
            # Convert DEC to Color
            __new_color = __color
            if to in ['rgb']:
                __opacity      = 255 - __color // 16777216
                __color        = (255 - __opacity) * 16777216
                __new_color    = [0, 0, 0]
                __new_color[0] = __color // 65536
                __color       -= __new_color[0] * 65536
                __new_color[1] = __color // 256
                __color       -= __new_color[1] * 256
                __new_color[2] = __color // 1
            elif to in ['rgba', 'hex']:
                __new_color = [0, 0, 0, 0]
                __new_color[3] = 255 - __color // 16777216
                __color       -= (255 - __new_color[3]) * 16777216
                __new_color[0] = __color // 65536
                __color       -= __new_color[0] * 65536
                __new_color[1] = __color // 256 
                __color       -= __new_color[1] * 256
                __new_color[2] = __color // 1
                if to in ['hex']:
                    for i in range(len(__new_color)):
                        __hex_color = hex(__new_color[i])
                        __hex_color = __hex_color[2:len(__hex_color)]
                        if len(__hex_color) == 1: __hex_color = '0' + __hex_color
                        __new_color[i] = __hex_color
                    __hex_color = __new_color
                    __new_color = ''
                    for canal in __hex_color:
                        __new_color += canal
            # Breakline
            self.cl = __new_color
            self.cn = to
            return self
                
        elif not to in self.types:
            self.cl = 0
            self.cn = 'dec'
            
    def edit(self, target:str='r', value:int=0, add:int=None):
        __mem_cn = self.cn
        __target = color.canals.index(target)
        if self.cn != 'rgba': self.convert(to = 'rgba')
        if add == None: self.cl[__target % 4] = value % 256
        else          : self.cl[__target % 4] = (self.cl[__target % 4] + add) % 256
        if __mem_cn != 'rgba': self.convert(to = __mem_cn)
        return self