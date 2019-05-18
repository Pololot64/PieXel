import pygame, os, math, sys, atexit
from utils import *
world = {}
player = Player()
color = Color()
textures = screen.find_textures()
player = Player(skin=Texture('skins/better_character.png'))
pygame.init()
screen.s.fill(color.blue)
player.draw()


for x in range(0, screen.width, screen.width//10):
    for y in range(0, screen.height, screen.height//10):
    
        if y/screen.t_size <= 5:
            pass
        elif y/screen.t_size == 6:
            screen.s.blit(textures['dirt.png'].img, tuple(Coord((x,y))))
        else:
            screen.s.blit(textures['dirt2.png'].img, tuple(Coord((x,y))))

pygame.display.flip()
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
    keys = pygame.key.get_pressed()
    if keys[pygame.K_a]:
        print('A')
        player.move(player.char_pos+Coord((1,0)))
        screen.update()
    elif keys[pygame.K_d]:
        player.move(player.char_pos+Coord((-1,0)))
        screen.s.fill((0,0,0))
        screen.update()
@atexit.register
def delete():
    for i in os.listdir('resized'):
        os.remove('resized/'+i)
        