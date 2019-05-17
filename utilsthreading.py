import threading, pygame, threading
lock = threading.Lock()
def start(char_pos, keys, screen):
    if keys[pygame.K_a]:
        creen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
        char_pos[0] -= 1
        screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
        pygame.display.flip()
    elif keys[pygame.K_d]:
        screen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
        char_pos[0] += 1
        screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
        pygame.display.flip()

