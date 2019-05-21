import pygame, threading, os, math, random, get_image_size
# TODO add api

class Texture:
    def __init__(self, texture_name):
        self.img_unscaled = pygame.image.load(texture_name)#.convert_alpha()
        self.img = self.img_unscaled
        self.texture_name = texture_name
        self.rect = self.img.get_rect()
    def resize(self, size):
        self.img = pygame.transform.scale(self.img_unscaled, size)

# TODO add more colors
palette = {
    'blue' : (18, 171, 255),
}

class Coord:


    def __init__(self, coord):
        self.coord = coord

    def __hash__(self):
        return hash(tuple(self.coord))

    def __repr__(self):
        return str(self.coord)

    def __getitem__(self, i):
        return self.coord[i]

    def __add__(self, other):
        return Coord((self[0] + other[0], self[1] + other[1]))

    def __sub__(self, other):
        return Coord((self[0] - other[0], self[1] - other[1]))

    def __mul__(self, other):
        return Coord((self[0] * other[0], self[1] * other[1]))

    def __eq__(self, other):
        return self.coord[1] == other.coord[1]

    def __gt__(self, other):
        return self.coord[1] > other.coord[1]

    def __lt__(self, other):
        return self.coord[1] < other.coord[1]

    def __tuple__(self):
        return tuple(self.coord)

# TODO Add more physics 
class Entity:


    def __init__(self, position):
        self.position = position
        self.velocity = Coord((0, 0))
        self.acceleration = Coord((0, 0))


    def step(self):
        self.velocity += self.acceleration
        self.position += self.velocity


    def accelerate(self, change_in_acceleration):
        self.acceleration += change_in_acceleration


class Screen(pygame.Surface):


    def __init__(self, sky_color=palette['blue'], size=(640,640)):
        pygame.init()
        pygame.Surface.__init__(self, size)
        self.screen = pygame.display.set_mode(size, pygame.DOUBLEBUF|pygame.HWSURFACE)
        self.sky_color = sky_color
        for i in os.listdir('textures'):
            if i.endswith('.png'):
                self.texture_size = get_image_size.get_image_size('textures/'+i)
        self.textures = self.find_textures(resize=True)


    def redraw(self):
        self.fill(palette['blue'])
        self.draw_screen()
        player.draw()
        self.update()


    def draw_screen(self):
        width, height = self.get_width(), self.get_height()
        for x in range(0, width, height//10):
            for y in range(0, height, height//10):
                if y/self.texture_size[1] <= 5:
                    pass
                elif y/self.texture_size == 6:
                    self.blit(self.textures['dirt_with_grass.png'].img, tuple(Coord((x,y))))
                else:
                    self.blit(self.textures['dirt.png'].img, tuple(Coord((x,y))))
        main_window = pygame.display.get_surface()
        main_window.blit(self, main_window.get_rect())


    def update(self):
            pygame.display.update()


    def find_textures(self, dir='textures/', format='.png', resize=False):
        textures = {}
        for i in os.listdir(dir):
            if i.endswith(format):
                textures[i] = Texture(dir+i)
                if resize:
                    textures[i].resize(self.texture_size)
        return textures


screen = Screen()

# TODO add player jump and physics  
class Player(Screen, Entity):

    def __init__(self, skin=Texture('skins/better_character.png'), char_pos=None):
        self.screen = screen
        if char_pos is None:
            self.char_pos = Coord((0, 0))
        else:
            self.char_pos = char_pos
        self.position = self.char_pos
        Entity.__init__(self, self.char_pos)
        self.skin = skin

    def draw(self):
        self.screen.blit(self.skin.img, self.position)


player = Player(skin=Texture('skins/better_character.png'), char_pos=Coord((0,50)))


class Mapgen():
    
    # TODO add biomes
    # Initializes a Mapgen object. All arguments are cast to integers.
    # seed - The seed used to randomly generate the terrain. Identical seeds will logically produce identical terrain.
    # max_height - The maximum height at which terrain will be generated (inclusive)
    # min_height - The minimum height at which terrain will be generated (inclusive)
    # Precondition: min_height <= max_height
    # first_sample_size - The interval at which the first sample will be done. Little to no effect on performance; larger values will generate smoother terrain.
    #
    # NOTE: Mapgen performance, depending on use, can be improved by lowering max_height or increasing min_height.
    #
    # Suggested test values, to give you an idea of how things work:
    # seed = <N/A>, max_height = 10, min_height = 0, first_sample_size = 20
    def __init__(self, seed, max_height, min_height, first_sample_size):

        self.seed = seed
        self.max_height = max_height
        self.min_height = min_height
        self.first_sample_size = first_sample_size

    # Returns type of block at specified position.
    # Returns "air", "ground", or "ground_surface"
    def blockAt(self, x, y):

        # First, a potential short-circuit evaluation for optimized results.
        # Not using >= and <= because max and min could possibly be surface ground.

        if y > self.max_height:
            return "air"

        if y < self.min_height:
            return "ground"

        # Proceeding if we actually need to generate the terrain...

        groundLevel = self.groundLevelAt(x)

        if y < groundLevel:
            return "ground"

        if y > groundLevel:
            return "air"

        return "ground_surface"

    # Returns the y-level of the terrain surface at the specified x-value.
    def groundLevelAt(self, x):

        # X-position of sample interval immediately to the left
        previous_sample = x - (x % self.first_sample_size)

        # X-position of sample interval immediately to the right
        next_sample = previous_sample + self.first_sample_size

        # Height of sample interval immediately to the left
        random.seed(self.seed + previous_sample)
        previous_sample_height = random.randint(self.min_height, self.max_height)

        # Height of sample interval immediately to the right
        random.seed(self.seed + next_sample)
        next_sample_height = random.randint(self.min_height, self.max_height)

        # Now we know the two bounding points around the requested position.
        # The next step is to find the value of x.

        # Slope between the two points
        slope = (previous_sample_height - next_sample_height) / self.first_sample_size

        # Height
        height = previous_sample_height + int((x - previous_sample) * (-slope))

        return height
    
    def generate(self, size_of_world:tuple):
        world = {}
        for x in range(size_of_world[0]):
            for y in range(size_of_world[1]):
                world[Coord((x,y))] = None
        for i in world:
            Y = self.groundLevelAt(i[0])
            world[Coord((i[0], Y))] = Block('default.dirt_with_grass.png', Texture('textures/dirt_with_grass.png'))
            for y in range(0,Y):
                world[Coord((x,y))] = Block('default.dirt', Texture('textures/dirt.png'))
        return world
    
    
class Block:
    def __init__(self, itemstring : str, texture : Texture):
        self.itemstring = itemstring
