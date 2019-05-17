import threading
def start(char_pos, keys, screen, pygame, lock):
    if keys[pygame.K_a]:
        with lock: screen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
        char_pos[0] -= 1
        with lock: screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
        pygame.display.flip()
    elif keys[pygame.K_d]:
        with lock: screen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
        char_pos[0] += 1
        with lock: screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
        pygame.display.flip()

