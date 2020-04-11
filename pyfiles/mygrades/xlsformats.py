from xlwt import *


fnt = Font()
fnt.name = 'Arial'

# header1
borders = Borders()
borders.bottom = Borders.THICK
pattern = Pattern()
pattern.pattern = Pattern.SOLID_PATTERN
pattern.pattern_fore_colour = 0x0A
header1 = XFStyle()
header1.font = fnt
header1.borders = borders
header1.pattern = pattern

#right1
borders = Borders()
borders.right = Borders.THICK
pattern = Pattern()
pattern.pattern = Pattern.SOLID_PATTERN
pattern.pattern_fore_colour = 0x0A
right1 = XFStyle()
right1.font = fnt
right1.borders = borders
right1.pattern = pattern

#right2
borders = Borders()
borders.right = Borders.THICK
pattern = Pattern()
pattern.pattern = Pattern.SOLID_PATTERN
pattern.pattern_fore_colour = 0x0A
right1 = XFStyle()
right1.font = fnt
right1.borders = borders
right1.pattern = pattern

# odd final
pattern = Pattern()
pattern.pattern = Pattern.SOLID_PATTERN
pattern.pattern_fore_colour = Style.colour_map['gray25']
odd = XFStyle()
odd.font = fnt
odd.pattern = pattern

# even final
pattern = Pattern()
pattern.pattern = Pattern.SOLID_PATTERN
pattern.pattern_fore_colour = Style.colour_map['light_yellow']
even = XFStyle()
even.font = fnt
even.pattern = pattern
