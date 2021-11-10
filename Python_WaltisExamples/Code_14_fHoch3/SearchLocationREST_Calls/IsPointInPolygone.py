from shapely.geometry import Point, Polygon
import plotly.express as px

ply = Polygon([(0, 0), (2, 0), (0, 2), (2, 2)])
poi = Point(1, 1)
x = [cord[0] for cord in ply.exterior.coords]
y = [cord[1] for cord in ply.exterior.coords]
color = ['Polygon' for cord in ply.exterior.coords]

x.append(poi.coords[0][0])
y.append(poi.coords[0][1])
color.append('Points')

fig = px.scatter(x= x, y=y, color=color)
fig.show()
print(ply.contains(poi))
