import pygame, os
from utils import *
# TODO add world saving
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
    # TODO add menu
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            os._exit(0)

    keys = pygame.key.get_pressed() #This works but it is good to use the event loop
    # TODO add more keys and keys api
    update_screen = False
    if keys[pygame.K_a]:
        player.accelerate((-1,0))
        update_screen = True
    elif keys[pygame.K_d]:
        player.accelerate((1,0))
        update_screen = True
    if update_screen:
        screen.redraw()