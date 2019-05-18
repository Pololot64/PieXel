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
            pygame.quit()
            sys.exit()

    keys = pygame.key.get_pressed() #This works but it is good to use the event loop

    if keys[pygame.K_a]:
        player.move(player.char_pos+Coord((-1,0)))

    elif keys[pygame.K_d]:
        player.move(player.char_pos+Coord((1,0)))

    screen.s.fill(color.blue)  #The screen should update even when no key is pressed?
    screen.draw_screen()
    player.draw()
    screen.update()