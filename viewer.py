import matplotlib.pyplot as plt
import numpy as np
from getImage import getImage


upperleft = '41.491274, -81.739349'
lowerright = '41.489401, -81.735496'

img = getImage(upperleft, lowerright)
plt.imshow(img)
plt.show()