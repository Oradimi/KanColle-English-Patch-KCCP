from PIL import Image, ImageDraw
import json
import random
import os

im = Image.open("battle_cutin_damage.png")
size = im.size

im.thumbnail(size, Image.ANTIALIAS)
data = json.loads(open("battle_cutin_damage.json").read())

txt = Image.new('RGBA', size, (255,255,255,0))
draw = ImageDraw.Draw(txt)
draw_direct = ImageDraw.Draw(im)

index = 0;
parts = []

class Part:
	pass;

for frame in data["frames"]:
	
	frame = data["frames"][frame]["frame"]
	
	index = index + 1;
	
	obj = Part()
	obj.x = frame['x']
	obj.y = frame['y']
	obj.w = frame['w']
	obj.h = frame['h']
	
	parts.append(obj)

taiha = parts[0];
chuuha = parts[1];
bg = parts[100];

proper_parts = []
best_fit = []
for part in range(0, 100):
	if part >= 2:
		proper_parts.append(part)
	best_fit.append((0,0,100000000))
	
from functools import cmp_to_key
proper_parts.sort(key=cmp_to_key(lambda p1, p2: parts[p2].w * parts[p2].h - parts[p1].w * parts[p1].h))

extra_data = [
(0, 175), 
(375, 181), 
(262, 160), 
(246, 321), 
(307, 298), 
(291, 273), 
(445, 355), 
(399, 334), 
(400, 310), 
(364, 291), 
(384, 280), 
(405, 268), 
(429, 309), 
(441, 262), 
(439, 247), 
(439, 258), 
(466, 241), 
(468, 201), 
(433, 156), 
(426, 208), 
(408, 162), 
(406, 241), 
(363, 250), 
(357, 265), 
(351, 216), 
(339, 157), 
(342, 156), 
(246, 105), 
(198, 148),
(168, 163), 
(216, 163), 
(247, 213), 
(172, 258), 
(177, 225), 
(142, 175), 
(69, 186), 
(0, 211), 
(49, 169), 
(139, 166), 
(157, 117), 
(133, 99), 
(1, 21), 
(4, 1), 
(124, 27),
(163, 72),
(213, 84),
(169, 1),
(121, 1),
(261, 186),
];

def generate_colors(n):
  rgb_values = []
  r = int(random.random() * 256)
  g = int(random.random() * 256)
  b = int(random.random() * 256)
  step = 256 / n
  for _ in range(n):
    r += step
    g += step
    b += step
    r = int(r) % 256
    g = int(g) % 256
    b = int(b) % 256
    r_hex = hex(r)[2:]
    g_hex = hex(g)[2:]
    b_hex = hex(b)[2:]
    rgb_values.append((r,g,b))
  return rgb_values
  
colors = generate_colors(51);
random.shuffle(colors)


def is_border(x, y):
	if im.getpixel((x,y))[3] != 0:
		coords = [(-1, 0), (1, 0), (0, -1), (0, 1)]
		for coord in coords:
			if x + coord[0] < 0 or y + coord[1] < 0:
				return True;
			if x + coord[0] >= size[0] or y + coord[1] >= size[1]:
				return True;
			
			if im.getpixel((x + coord[0], y + coord[1]))[3] == 0:
				return True;
	return False;

#proper_parts = proper_parts[20:40]

# fill jigsaw pieces into their positions to verify that coordinates are right	
for part in proper_parts:
	elem = parts[part]
	
	draw.text((elem.x, elem.y), "%d" % part, fill=(0,0,0,255))
	
	if part <= 50:
		source = chuuha
		delta = (-chuuha.x + taiha.x, -chuuha.y + taiha.y)
	else:
		source = taiha
		part = part - 49
		delta = (-taiha.x + chuuha.x, -taiha.y + chuuha.y)
	
	p = extra_data[part - 2];

	#draw.rectangle([source.x + p[0], source.y + p[1],
	#	source.x + p[0] + elem.w, source.y + p[1] + elem.h],
	#	outline=colors[part],
	#	fill=colors[part])
	#	
	#draw.rectangle([elem.x, elem.y,
	#	elem.x + elem.w, elem.y + elem.h],
	#	outline=colors[part])
		
	# blit blit the original image
	for x in range(0, elem.w):
		for y in range(0, elem.h):
			patpix = im.getpixel((x + elem.x, y + elem.y));
			if patpix[3] == 0:
				continue

			#im.putpixel((source.x + p[0] + x, source.y + p[1] + y), patpix)
			border = is_border(x + elem.x, y + elem.y);
			if border:
				im.putpixel((source.x + p[0] + x, source.y + p[1] + y), (255,0,0,255))
				#im.putpixel((source.x + p[0] + x + delta[0], source.y + p[1] + y + delta[1]), (0,255,0,255))
				im.putpixel((x + elem.x, y + elem.y), (255,0,0,255))
				
# generate the polygons
polygons = {43 : [
	(0, 0),
	(5, 0),
	(90, 54),
	(130, 65),
	(140, 150),
	(13, 155),
	(0, 155),
],
48 : [
	(10, 0),
	(160, 0),
	(160, 84),
	(61, 109),
	(25, 100),
	(1, 72),
	],
50 : [
	(47, 26),
	(82, 1),
	(97, 86),
	(7, 127),
	(79, 61),
],
34 : [
	(0, 0),
	(76, 0),
	(113, 38),
	(96, 55),
	(119, 45),
	(134, 60),
	(134, 63),
	(74, 86),
	(0, 86),
	],
37 : [
	(0, 25),
	(65, 0),
	(73, 0),
	(86, 108),
	(44, 102),
	],
38 : [
	(0, 0),
	(69, 0),
	(113, 77),
	(121, 78),
	(121, 86),
	(0, 86),
	],
47 : [
	(17, 26),
	(79, 10),
	(101, 43),
	(36, 65),
	(30, 65),
	(10, 45),
	],
5 : [
	(0, 23),
	(59, 0),
	(104, 41),
	(108, 74),
	(0, 74),
	],
15 : [
	(0, 40),
	(22, 0),
	(58, 0),
	(58, 143),
	(45, 143),
	(0, 89),
	],
29 : [
	(0, 45),
	(68, 22),
	(53, 0),
	(167, 0),
	(167, 50),
	(10, 56),
	],
32 : [
	(25, 0),
	(44, 0),
	(89, 47),
	(89, 50),
	(32, 95),
	(0, 95),
	(0, 58),
	],
33 : [
	(0, 45),
	(60, -2),
	(93, 34),
	(39, 84),
	],
6 : [
	(0, 25),
	(57, 0),
	(75, 97),
	(47, 97),
	(43, 64),
	],
46 : [
	(6, 0),
	(33, 30),
	(68, 38),
	(60, 56),
	(80, 77),
	(60, 82),
	(0, 46),
	],
35 : [
	(0, 0),
	(39, 0),
	(39, 33),
	(0, 33),
	],
28 : [
	(0, 30),
	(35, 0),
	(70, 0),
	(70, 26),
	(10, 80),
	],
20 : [
	(0, 0),
	(67, 0),
	(67, 51),
	(6, 79),
	(0, 46),
	],
31 : [
	(0, 13),
	(34, 0),
	(73, 0),
	(46, 62),
	(0, 62),
	],
11 : [
	(0, 8),
	(19, 0),
	(40, 19),
	(40, 103),
	(18, 104),
	],
4 : [
	(0, 1),
	(25, 0),
	(77, 0),
	(80, 27),
	(45, 52),
	(0, 5),
	],
45 : [
	(4, 4),
	(46, 44),
	(39, 91),
	(9, 73),
	(8, 71),
	],
2 : [
	(0, 1),
	(27, 0),
	(68, 0),
	(68, 36),
	(0, 36),
	],
49 : [
	(5, 0),
	(58, 0),
	(50, 71),
	(7, 31),
	],
39 : [
	(19, 5),
	(94, 0),
	(94, 17),
	(84, 17),
	(23, 41),
	(19, 41),
	],
41 : [
	(3, 0),
	(4, 0),
	(67, 37),
	(71, 35),
	(71, 46),
	(45, 47),
	(35, 50),
	(0, 50),
	],
7 : [
	(0, 30),
	(64, 0),
	(73, 25),
	(23, 47),
	(16, 49),
	],
9 : [
	(27, 0),
	(49, 25),
	(44, 70),
	(5, 70),
	(5, 40),
	],
21 : [
	(1, 32),
	(68, 2),
	(68, 50),
	(32, 50),
	],
26 : [
	(1, 20),
	(23, 0),
	(56, 16),
	(56, 34),
	(12, 55),
	(7, 55),
	],
8 : [
	(3, 5),
	(41, 50),
	(0, 50),
	(0, 32),
	],
22 : [
	(4, 0),
	(25, 0),
	(25, 42),
	(31, 72),
	(0, 86),
	(0, 24),
	(4, 20),
	],
13 : [
	(0, 14),
	(34, 0),
	(36, 33),
	(22, 67),
	(0, 42),
	],
19 : [
	(20, 12),
	(41, 24),
	(27, 55),
	(7, 37),
	],
42 : [
	(0, 2),
	(27, 17),
	(24, 67),
	(8, 70),
	],
10 : [
	(4, 0),
	(26, 24),
	(4, 64),
	],
18 : [
	(0, 17),
	(28, 17),
	(36, 0),
	(43, 0),
	(43, 44),
	(33, 44),
	(33, 21),
	(0, 21),
	],
24 : [
	(0, 21),
	(44, 0),
	(44, 31),
	(25, 41),
	(19, 40),
	],
3 : [
	(0, 35),
	(33, 4),
	(33, 50),
	(29, 50),
	],
17 : [
	(0, 10),
	(24, 0),
	(28, 0),
	(27, 4),
	(24, 4),
	(2, 44),
	],
23 : [
	(1, 40),
	(1, 8),
	(21, -1),
	(33, 6),
	(33, 27),
	],
27 : [
	(3, 28),
	(0, 0),
	(37, 0),
	],
40 : [
	(4, 3),
	(15, 1),
	(54, 1),
	(29, 11),
	(27, 9),
	(19, 9),
	(4, 16),
	],
30 : [
	(30, 5),
	(47, 0),
	(59, 13),
	(61, 13),
	(56, 15),
	(45, 16),
	(30, 16),
	],
25 : [
	(7, 34),
	(26, 26),
	(6, 6),
	(0, 8),
	(1, 15),
	],
14 : [
	(9, 0),
	(12, -3),
	(12, 42),
	(0, 29),
	(0, 20),
	],
12 : [
	(0, 12),
	(21, 2),
	(21, 29),
	(19, 29),
	],
16 : [
	(0, 0),
	(19, 11),
	(22, 11),
	(3, 20),
	(0, 20),
	],
36 : [
	(0, 7),
	(15, 0),
	(32, 0),
	(50, 37),
	(30, 140),
	(13, 119),
	],
44 : [
	(0, 0),
	(122, 0),
	(127, 84),
	(80, 78),
	(0, 19),
	],
}

# write polygons first
poly_image = Image.new('RGBA', size, (255,255,255,0))
draw_poly_image = ImageDraw.Draw(poly_image)
		
parts_to_fix = proper_parts[:]
for part in polygons:
	poly = polygons[part]
	
	if part <= 50:
		source = chuuha
		pi = part
	else:
		continue
	
	p = extra_data[pi - 2];
	
	parts_to_fix.remove(part)
	if part + 49 in parts_to_fix:
		parts_to_fix.remove(part + 49)

	poly_adjusted = []
	for coord in poly:
		poly_adjusted.append( (coord[0] + chuuha.x + p[0], coord[1] + chuuha.y + p[1]) )
	
	draw_direct.polygon(poly_adjusted, fill = (128, 128, pi, 255),
		outline = (0, 255, pi, 255))
	draw_poly_image.polygon(poly_adjusted, fill = (128, 128, pi, 255),
		outline = (128, 128, pi, 255))
		
	poly_adjusted = []
	for coord in poly:
		poly_adjusted.append( (coord[0] + taiha.x + p[0], coord[1] + taiha.y + p[1]) )
	
	draw_direct.polygon(poly_adjusted, fill = (128, 128, pi + 49, 255),
		outline = (0, 255, pi + 49, 255))
	draw_poly_image.polygon(poly_adjusted, fill = (128, 128, pi + 49, 255),
		outline = (128, 128, pi + 49, 255))

if len(parts_to_fix) > 0:
	color_sequence = [(195, 195, 195), (185, 122, 87), (255, 174, 201), (255, 201, 14), (239, 228, 176),
		(181, 230, 29), (153, 217, 234), (112, 146, 190), (200, 191, 231)]
		
	#print (parts_to_fix)
	#
	new_im = parts_to_fix[0];
	path_to_next_poly = "parts//part_%d.png" % new_im

	if os.path.exists(path_to_next_poly):
		new_poly = Image.open(path_to_next_poly)
		print ("%d : [" % new_im);
		for ci in range(0, len(color_sequence)):
			pos = None;
			cur = color_sequence[ci]
			for x in range(0, new_poly.size[0]):
				for y in range(0, new_poly.size[1]):
					col = new_poly.getpixel((x, y))
					col = (col[0], col[1], col[2])
					if col == cur:
						pos = (x, y)
						break;
				if pos is not None:
					break;
					
			if pos is not None:
				#print( "%d goes to %d x %d" % (ci, pos[0], pos[1]))
				print("(%d, %d)," % pos)
			else:
				print ("],");
				print( "%d not found" % ci)
				break;
	else:
		# generate image
		part = new_im
		elem = parts[part]
		
		if part <= 50:
			source = chuuha
			pi = part
		else:
			source = taiha
			pi = part - 49
		
		p = extra_data[pi - 2];
			
		part_image = Image.new('RGBA', (elem.w, elem.h), (255,255,255,0))
		
		for x in range(0, elem.w):
			for y in range(0, elem.h):
				part_image.putpixel((x, y), im.getpixel((x + source.x + p[0], y + source.y + p[1])))

		for x in range(0, elem.w):
			for y in range(0, elem.h):
				patpix = im.getpixel((x + elem.x, y + elem.y));
				if patpix[3] == 0:
					continue

				#im.putpixel((source.x + p[0] + x, source.y + p[1] + y), patpix)
				border = is_border(x + elem.x, y + elem.y);
				if border:
					part_image.putpixel((x, y), (0,0,255,255))

		part_image.save("parts//part_%d.png" % part, "PNG")

en_im = Image.open("battle_cutin_damage_EN_base.png")

# this puts english text on original image
# for x in range(0, chuuha.w):
# 	for y in range(0, chuuha.h):
# 		if en_im.getpixel((x + chuuha.x, y + chuuha.y))[3] > 0:
# 			im.putpixel((x + chuuha.x, y + chuuha.y), en_im.getpixel((x + chuuha.x, y + chuuha.y)))
# for x in range(0, taiha.w):
# 	for y in range(0, taiha.h):
# 		if en_im.getpixel((x + taiha.x, y + taiha.y))[3] > 0:
# 			im.putpixel((x + taiha.x, y + taiha.y), en_im.getpixel((x + taiha.x, y + taiha.y)))
			
# write actual result
jp_im = Image.open("battle_cutin_damage.png")
final_image = Image.new('RGBA', size, (255,255,255,0))

# copy background and uncut images
for x in range(0, bg.w):
	for y in range(0, bg.h):
		final_image.putpixel((bg.x + x, bg.y + y), jp_im.getpixel((bg.x + x, bg.y + y)))
			
for static in (chuuha, taiha):
	for x in range(0, static.w):
		for y in range(0, static.h):
			final_image.putpixel((static.x + x, static.y + y), en_im.getpixel((static.x + x, static.y + y)))
			
# put jigsaw parts
for part in proper_parts:
	
	elem = parts[part]
	
	if part <= 50:
		source = chuuha
		pi = part
	else:
		source = taiha
		pi = part - 49
		
	p = extra_data[pi - 2];
	
	for x in range(0, elem.w):
		for y in range(0, elem.h):
			# take elem positions
			if poly_image.getpixel((x + source.x + p[0], y + source.y + p[1]))[2] == part:
				final_image.putpixel((x + elem.x, y + elem.y), en_im.getpixel((x + source.x + p[0], y + source.y + p[1]))) 
	 
#draw_direct = ImageDraw.Draw(final_image)
#for part in proper_parts:
#	
#	if part <= 50:
#		source = chuuha
#		pi = part
#	else:
#		source = taiha
#		pi = part - 49
#		
#	p = extra_data[pi - 2];
#	
#	poly_adjusted = []
#	poly = polygons[pi]
#	
#	c = 128
#	
#	for coord in poly:
#		poly_adjusted.append( (coord[0] + chuuha.x + p[0], coord[1] + chuuha.y + p[1]) )
#	
#	draw_direct.polygon(poly_adjusted, outline = (c, c, pi, 255))
#		
#	poly_adjusted = []
#	for coord in poly:
#		poly_adjusted.append( (coord[0] + taiha.x + p[0], coord[1] + taiha.y + p[1]) )
#	
#	draw_direct.polygon(poly_adjusted, outline = (c, c, pi + 49, 255))
	 
final_image.save("battle_cutin_damage_generated.png", "PNG")

out = Image.alpha_composite(im, txt)
out.save("battle_cutin_damage_solved.png", "PNG")
