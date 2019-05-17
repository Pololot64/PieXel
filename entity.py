class Entity:


    def __init__(self, position):
        self.position = position
        self.velocity = (0, 0)
        self.acceleration = (0, 0)


    def __step(self):
        self.velocity = (self.velocity[0] + self.acceleration[0],
                         self.velocity[1] + self.acceleration[1])

        self.position = (self.position[0] + self.velocity[0],
                         self.position[1] + self.velocity[1])


    def accelerate(self, change_in_acceleration):
        self.acceleration = (self.acceleration[0] + change_in_acceleration[0],
                             self.acceleration[1] + change_in_acceleration[1])