# IMW.scripts.py

# –––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––– #

class Imw:
    """
    IMW class :\n
    \xA0\xA0- .img -> image array      ;\n
    \xA0\xA0- .res -> image resolution ;\n
    \xA0\xA0- .ysz -> image height     ;\n
    \xA0\xA0- .xsz -> image width      ;\n
    """
    def __init__(self, ysize:int=0, xsize:int=0):
        self.img = [[Color(type = 'rgba', value = [0, 0, 0, 0]) for x in range(xsize)] for y in range(ysize)]
        self.res = 1
        self.ysz = ysize
        self.xsz = xsize
        
    def crop(self, xsize:int='', ysize:int=''):
        """
        [IMW / Crop]: Add / Remove pixels to crop an IMW.\n
        \xA0\xA0- xsize (width)  ;\n
        \xA0\xA0- ysize (height) ;\n
        \xA0\xA0- clrwith (color) ;
        """
        # Asserts
        if xsize == self.xsz and ysize == self.ysz or (xsize < 0 or ysize < 0): return self
        # Variables
        __old_x = self.xsz
        __old_y = self.ysz
        __new_image = []
        # Croping image
        for line in range(ysize):
            __new_image.append([])
            for pixel in range(xsize):
                if line +1 <= __old_y and pixel +1 <= __old_x:
                        __new_image[line].append(self.img[line][pixel])
                else:
                    __new_image[line].append(Color(type = 'rgba', value = [0, 0, 0, 0]))
        # Buidling Image
        self.xsz = xsize
        self.ysz = ysize
        self.img = __new_image
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
                __build_line += str(pixel.convert(to = 'dec').cl) + '/'
            __build += __build_line + '#/'    
        return __build + '◊Created with IMW-PYTHON◊'
        
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
                    __img_color = Color(type = 'dec', value = int(__img_pixel))
                    __img_line.append(__img_color.convert(to = 'rgba'))
                    __img_line_x += 1
                __img_pixel = ''
            else:
                __img_pixel += code[idx]
            idx += 1
            
        if idx > __len_code: return None
                
        # Croping Image
        for line in range(len(__img)):
            if len(__img[line])  != __max_x:
                for el in range(round((__max_x - len(__img[line])) / 2 + -.4)):
                    __img[line].insert(0, Color(type = 'rgba', value = [0, 0, 0, 0]))
                for el in range(round((__max_x - len(__img[line])) / 2 + +.4)):
                    __img[line].append(Color(type = 'rgba', value = [0, 0, 0, 0]))
                    
        self.img = __img
        self.res = __res
        self.xsz = __max_x
        self.ysz = __ysz
        
        return self
    
    def edit(self, x : int = 0, y : int = 0, color : list = [0, 0, 0, 0]):
        """
        [IMW / Edit]: Edit a pixel inside an IMW object.\n
        \xA0\xA0- x (0, xsz -1) ;\n
        \xA0\xA0- y (0, ysz -1) ;\n
        \xA0\xA0- color (rgba list) ;\n
        """
        if len(color) != 4: return self 
        if x >= self.xsz or y >= self.ysz or x < 0 or y < 0: return self
        for i in range(len('rgba')):
            self.img[y][x].edit(target = 'rgba'[i], value = color[i])
        return self

class Color:
    """
    Color class :\n
    \xA0\xA0- .types  -> working color formats [:list] ;\n
    \xA0\xA0- .cn     -> current color format  [:str]  ;\n
    \xA0\xA0- .cl     -> current color code    [:any]  ;\n
    """
    types  = ['dec', 'rgba']
    canals = ['r', 'g', 'b', 'a']
        
    def __init__(self, type:str='dec', value:int=0):
        """
        [Color / Init]: [dec:int] represent a decimal scratch color
        """
        self.cn = type
        self.cl = value
        
    def convert(self, to:str='dec'):
        if self.cn != to and to in self.types:
            # Get Color
            __color = 0
            if self.cn in ['dec']:
                __color = self.cl
            elif self.cn in ['rgba']:
                __color = (((255 - self.cl[3]) * 256 + self.cl[0]) * 256 + self.cl[1]) * 256 + self.cl[2]
            # Convert DEC to Color
            __new_color = __color
            if to in ['rgba']:
                __new_color = [0, 0, 0, 0]
                __new_color[3] = 255 - __color // 16777216
                __color       -= (255 - __new_color[3]) * 16777216
                __new_color[0] = __color // 65536
                __color       -= __new_color[0] * 65536
                __new_color[1] = __color // 256 
                __color       -= __new_color[1] * 256
                __new_color[2] = __color // 1
            # Breakline
            self.cl = __new_color
            self.cn = to
            return self
                
        elif not to in self.types:
            self.cl = 0
            self.cn = 'dec'
            
    def edit(self, target:str='r', value:int=0, add:int=None):
        __mem_cn = self.cn
        __target = Color.canals.index(target)
        if self.cn != 'rgba': self.convert(to = 'rgba')
        if add == None: self.cl[__target % 4] = value % 256
        else          : self.cl[__target % 4] = (self.cl[__target % 4] + add) % 256
        if __mem_cn != 'rgba': self.convert(to = __mem_cn)
        return self
