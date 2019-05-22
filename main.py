import pygame, os, threading
from utils import *
import settings
# TODO add world saving
size_of_world = (100,50)
world = {}
mapgen = Mapgen(
    seed = random.randint(0,1000000000),
    max_height = 100,
    min_height = 0,
    first_sample_size = 10,
)
def gen():
    world = mapgen.generate((100,100))
mapgen_thread = threading.Thread(target=gen, daemon=True)
mapgen_thread.start()
textures = screen.textures


main_window = pygame.display.set_mode(settings.screen_size)
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

    player.step()