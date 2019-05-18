import pygame
from PIL import Image
class Texture:
    def __init__(self, texture_name):
        self.img = pygame.image.load(texture_name)
        self.texture_name = texture_name
        self.rect = self.img.get_rect()
    def resize(self, size):
        img = Image.open(self.texture_name)
        img = img.resize(size) 
        img.save('resized/'+self.texture_name[len('textures/'):], self.texture_name[-3:])
        self.__init__('resized/'+self.texture_name[len('textures/'):])
