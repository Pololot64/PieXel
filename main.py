import pygame, os, math, sys, atexit
from utils import *
world = {}
textures = {}
player = Player()
color = Color()
pygame.init()
screen.fill(color.blue)
player = Player(skin=Texture('skins/better_character.png'))


for x in range(0, screen.width, screen.width//10):
    for y in range(0, screen.height, screen.height//10):
    
        if y/screen.t_size <= 5:
            pass
        elif y/screen.t_size == 6:
            screen.blit(textures['dirt.png'].img, Coord((x,y)).__repr__())
        else:
            screen.blit(textures['dirt2.png'].img, Coord((x,y)).__repr__())

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
        