import pygame
pygame.init()
size = width, height = 640, 640
blue = 18, 171, 255
world = {}
screen = pygame.display.toggle_fullscreen()
screen.fill(blue)
pygame.display.flip()
for x in range(0, 640, 64):
	for y in range(0, 640, 64):
		if y/64 <= 5:
			pass
		elif y/64 == 6:
			screen.blit(pygame.image.load('textures/dirt.png'), (x, y))
		else:
			screen.blit(pygame.image.load('textures/dirt2.png'), (x, y))

char_pos = [320, 320]
screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
pygame.display.flip()

while True:
	for event in pygame.event.get():
		if event.type == pygame.QUIT:
			sys.exit()
	keys = pygame.key.get_pressed()
	if keys[pygame.K_a]:
		screen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
		char_pos[0] -= 1
		screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
		pygame.display.flip()
	elif keys[pygame.K_d]:
		screen.blit(pygame.image.load('textures/sky_char.png'), tuple(char_pos))
		char_pos[0] += 1
		screen.blit(pygame.image.load('textures/pie_character_64x128.png'), tuple(char_pos))
		pygame.display.flip()