import pygame, os, math, sys, atexit
from utils import *
world = {}
player = Player()
color = Color()
textures = screen.find_textures()

pygame.init()
screen.s.fill(color.blue)
player.draw()
screen.draw_screen()

pygame.display.flip()
while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
    keys = pygame.key.get_pressed()
    if keys[pygame.K_a]:
        print('A')
        player.move(player.char_pos+Coord((1,0)))
        screen.s.fill(color.blue)
        screen.draw_screen()
        player.draw_player()
        screen.update()
        
    elif keys[pygame.K_d]:
        player.move(player.char_pos+Coord((-1,0)))
        screen.s.fill(color.blue)
        screen.draw_screen()
        player.draw_player()
        screen.update()
@atexit.register
def delete():
    for i in os.listdir('resized'):
        os.remove('resized/'+i)
        