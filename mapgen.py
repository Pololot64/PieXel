import random
import math

# Mapgen class
class Mapgen():
    
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
    def __init__(self, seed : int, max_height : int, min_height : int, first_sample_size : int):

        self.seed = seed
        self.max_height = max_height
        self.min_height = min_height
        self.first_sample_size = first_sample_size

    # Returns type of block at specified position.
    # Returns "air", "ground", or "ground_surface"
    def blockAt(self, x : int, y : int):

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
    def groundLevelAt(self, x : int):

        # X-position of sample interval immediately to the left
        previous_sample = x - (x % self.first_sample_size)

        # X-position of sample interval immediately to the right
        next_sample = previous_sample + self.first_sample_size

        # Height of sample interval immediately to the left
        random.seed(self.seed + previous_sample)
        previous_sample_height = random.randint(self.min_height, self.max_height)
        print("PREV", previous_sample, previous_sample_height)

        # Height of sample interval immediately to the right
        random.seed(self.seed + next_sample)
        next_sample_height = random.randint(self.min_height, self.max_height)
        print("NEXT", next_sample, next_sample_height)

        # Now we know the two bounding points around the requested position.
        # The next step is to find the value of x.

        # Slope between the two points
        slope = (previous_sample_height - next_sample_height) / self.first_sample_size
        print("SLOPE", slope)

        # Height
        height = previous_sample_height + int((x - previous_sample) * (-slope))

        return height


