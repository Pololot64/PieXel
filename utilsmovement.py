import pygame
def a(char_pos):
    screen.blit(pygame.image.load('sky_char.png'), tuple(char_pos))
    char_pos[0] -= 1
    screen.blit(pygame.image.load('pie_character_64x128.png'), tuple(char_pos))
    pygame.display.flip()
    return char_pos