import pygame, threading, os
# TODO add api
# TODO add mapgen

class Texture:
    def __init__(self, texture_name):
        self.img_unscaled = pygame.image.load(texture_name).convert_alpha()
        self.img = self.img_unscaled
        self.texture_name = texture_name
        self.rect = self.img.get_rect()
    def resize(self, size):
        self.img = pygame.transform.scale(self.img_unscaled, size)

# TODO add more colors
class Color:
    def __init__(self):
        self.blue = 18, 171, 255

class Coord:


    def __init__(self, coord):
        self.coord = coord

    def __repr__(self):
        return str(self.coord)

    def __getitem__(self, i):
        return self.coord[i]

    def __add__(self, other):
        return Coord((self[0] + other[0], self[1] + other[1]))

    def __sub__(self, other):
        return Coord((self[0] - other[0], self[1] - other[1]))

    def __mul__(self, other):
        return Coord((self[0] * other[0], self[1] * other[1]))

    def __eq__(self, other):
        return self.coord[1] == other.coord[1]

    def __gt__(self, other):
        return self.coord[1] > other.coord[1]

    def __lt__(self, other):
        return self.coord[1] < other.coord[1]

    def __tuple__(self):
        return tuple(self.coord)

# TODO Add more physics 
class Entity:

    def __init__(self, position=Coord((0,0))):
        self.position = position
        self.velocity = Coord((0, 0))
        self.acceleration = (0, 0)

    def __step(self):
        self.velocity = (self.velocity[0] + self.acceleration[0],
                         self.velocity[1] + self.acceleration[1])

        self.position = (self.position[0] + self.velocity[0],
                         self.position[1] + self.velocity[1])

    def accelerate(self, change_in_acceleration):
        self.acceleration = (self.acceleration[0] + change_in_acceleration[0],
                             self.acceleration[1] + change_in_acceleration[1])


class Screen(Color):

    def __init__(self, sky_color=(18, 171, 255), size=(640,640), blocks_in_screen=10):
        self.size = size
        self.width = size[0]
        self.height = size[1]
        self.sky_color = sky_color
        self.screen = pygame.display.set_mode(size, pygame.DOUBLEBUF|pygame.HWSURFACE)
        self.blocks_in_screen = blocks_in_screen
        self.block = round(self.width/blocks_in_screen), round(self.height // blocks_in_screen)
        self.t_size = round(self.width/10)
        self.textures = self.find_textures()
        self.display = pygame.display
        self.s = self.screen

    def draw_player(self):
        player.draw()
    def redraw(self):
        self.s.fill(color.blue)
        self.draw_screen()
        player.draw()
        self.update()
    def draw_screen(self):
        for x in range(0, self.width, self.width//10):
            for y in range(0, self.height, self.height//10):
                if y/self.t_size <= 5:
                    pass
                elif y/self.t_size == 6:
                    self.screen.blit(self.textures['dirt.png'].img, tuple(Coord((x,y))))
                else:
                    self.screen.blit(self.textures['dirt2.png'].img, tuple(Coord((x,y))))

    def update(self):
            pygame.display.update()

    def find_textures(self, dir='textures/', format='.png', resize=False):
        textures = {}
        for i in os.listdir(dir):
            if i.endswith(format):
                textures[i] = Texture(dir+i)
                if resize:
                    textures[i].resize(self.t_size)
        return textures

    def blit(self, image, pos):
        self.s.blit(image, tuple(pos))

screen = Screen()

# TODO add player jump and physics  
class Player(Entity, Screen):

    def __init__(self, skin=Texture('skins/better_character.png'), char_pos=None):
        self.screen = screen
        if char_pos is None:
            self.char_pos = Coord((0, self.screen.block[1]*4))
        else:
            self.char_pos = Coord(char_pos)
        self.skin = skin

    def draw(self, coords=None):
        if coords is None:
            coords = self.char_pos
        self.screen.blit(self.skin.img, self.char_pos)

    def move(self, new_pos=Coord((1,0))):
        screen.blit(self.skin.img, tuple(self.char_pos - new_pos))
        self.char_pos = new_pos


player = Player(skin=Texture('skins/better_character.png'))
