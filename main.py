import pygame, threading, utilsmovement, utilsthreading
lock = threading.Lock()
pygame.init()
size = width, height = 640, 640
blue = 18, 171, 255
screen = pygame.display.set_mode(size)
screen.fill(blue)
pygame.display.flip()
for x in range(0, 640, 64):
    for y in range(0, 640, 64):
        if y/64 <= 5:
            pass
        elif y/64 == 6:
            with lock: screen.blit(pygame.image.load('textures/dirt.png'), (x, y))
        else:
            with lock: screen.blit(pygame.image.load('textures/dirt2.png'), (x, y))
char_pos = [0, 64*4]
with lock: screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
pygame.display.flip()

while 1:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            sys.exit()
    keys = pygame.key.get_pressed()
    threading.Thread(target=utilsthreading.start, args=(char_pos, keys, screen)).start()
