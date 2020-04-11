from xlwt import *
# HEADER 1
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
fnt.bold = True
borders = Borders()
borders.bottom = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
header1 = XFStyle()
header1.font = fnt
header1.borders = borders
#header1.pattern = pattern

# RIGHT 1
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
right1 = XFStyle()
right1.font = fnt
right1.borders = borders
#right1.pattern = pattern
right1.num_format_str = '0.00'
# RIGHT 1
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
right1b = XFStyle()
right1b.font = fnt
right1b.borders = borders
#right1b.pattern = pattern
right1b.num_format_str = '0.00'
# RIGHT 2
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
fnt.italic = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
right2 = XFStyle()
right2.font = fnt
right2.borders = borders
#right2.pattern = pattern
right2.num_format_str = '0.00'
# RIGHT 2
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
fnt.italic = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
right2b = XFStyle()
right2b.font = fnt
right2b.borders = borders
#right2b.pattern = pattern
right2b.num_format_str = '0.00'

#
# ROWER 1
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
fnt.italic = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
rower1 = XFStyle()
rower1.font = fnt
rower1.borders = borders
#rower1.pattern = pattern
# ROWER 1
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x00
fnt.italic = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
rower1b = XFStyle()
rower1b.font = fnt
rower1b.borders = borders
#rower1b.pattern = pattern

# ROWER 2
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x30
fnt.bold = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
rower2 = XFStyle()
rower2.font = fnt
rower2.borders = borders
#rower2.pattern = pattern
rower2.num_format_str = '0.00'
# ROWER 2b disc ( for distinction in multiple rows)
fnt = Font()
fnt.name = 'Arial'
fnt.colour_index = 0x30
fnt.bold = True
borders = Borders()
borders.right = Borders.THICK
#pattern = Pattern()
#pattern.pattern = Pattern.SOLID_PATTERN
#pattern.pattern_fore_colour = 0xFF
#
rower2b = XFStyle()
rower2b.font = fnt
rower2b.borders = borders
#rower2b.pattern = pattern
rower2b.num_format_str = '0.00'

# array for multiple rows distinction
rower1arr = (rower1,rower1b)
rower2arr = (rower2,rower2b)
right1arr = (right1,right1b)
right2arr = (right2,right2b)



