import matplotlib.pyplot as plt
import numpy as np
from getImage import getImage
from rpy2.robjects.packages import importr

lidR = importr('lidR')
las_merged = lidR.readLAS("../CLNP_merged_44_62_1.3.las")

exit()

upperleft = '41.491274, -81.739349'
lowerright = '41.489401, -81.735496'

img = getImage(upperleft, lowerright)
plt.imshow(img)
plt.show()