import pygame, os, math, sys, atexit
from textures import Texture
from entity import Entity
pygame.init()
size = width, height = 640, 640
blue = 18, 171, 255
world = {}
screen = pygame.display.set_mode(size)
screen.fill(blue)
blocks_in_screen = 10
block = width/blocks_in_screen, height // blocks_in_screen
t_size = width//10
t_size_i = width//10,height//10
textures = {}
class Coord:
    def __init__(self, coord):
        self.coord = [coord[0], coord[1]]
    def __sub__(self, other):
        return tuple(self.coord[0] - tuple(other)[0], self.coord[1] - tuple(other)[1])
    def __tuple__(self):
        return (self.coord[0], self.coord[1])
    def __iter__(self):
        yield from self.coord
    def __eq__(self, other):
        if self.coord[0] == other[0] and self.coord[1] == other[1]:
            return True
    def __add__(self, other):
        return Coord((self.coord[0]+other[0], self.coord[1]+other[1]))
    def __lt__(self, other):
        lt = [True] if self.coord[0] < other[0] else [False]
        lt.append(True) if self.coord[1] < other[1] else False
        return tuple(lt)
    def __gt__(self, other):
        lt = [True] if self.coord[0] > other[0] else [False]
        lt.append(True) if self.coord[1] > other[1] else False
        return tuple(lt)
    def __repr__(self):
        return tuple(self.coord)
class Player(Entity):
    def __init__(self, skin=Texture('skins/better_character.png'), char_pos=(0, block[1]*4)):
        print(char_pos)
        self.pos = Coord(char_pos)
        screen.blit(skin.img, self.pos.__repr__())
        self.skin = skin

    def move(self, new_pos=Coord((1,0))):
        self.skin.rect.move(tuple(new_pos)-tuple(self.pos))
        self.pos = new_pos

player = Player(skin=Texture('skins/better_character.png'))
for i in os.listdir('textures'):
    if i.endswith('.png'):
        textures[i] = Texture('textures/'+i)
        textures[i].resize(t_size_i)
for x in range(0, width, width//10):
    for y in range(0, height, height//10):
        print(y/t_size)
        try:
            if y/t_size <= 5:
                pass
            elif y/t_size == 6:
                screen.blit(textures['dirt.png'].img, Coord((x,y)).__repr__())
            else:
                screen.blit(textures['dirt2.png'].img, Coord((x,y)).__repr__())
        except:
            #print('Error on(',str(x)+', '+str(y),end=')\n')
            pass

pygame.display.flip()
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
    keys = pygame.key.get_pressed()
    if keys[pygame.K_a]:
        player.move(player.pos+Coord((1,0)))
        pygame.display.flip()
    elif keys[pygame.K_d]:
        player.move(player.pos+Coord((-1,0)))
        pygame.display.flip()
@atexit.register
def delete():
    for i in os.listdir('resized'):
        os.remove('resized/'+i)
        