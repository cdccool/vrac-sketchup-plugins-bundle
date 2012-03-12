=begin
#-------------------------------------------------------------------------------------------------------------------------------------------------
#*************************************************************************************************
# Designed by Fredo6 - Copyright April 2009

# Permission to use this software for any purpose and without fee is hereby granted
# Distribution of this software for commercial purpose is subject to:
#  - the expressed, written consent of the author
#  - the inclusion of the present copyright notice in all copies.

# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#-----------------------------------------------------------------------------
# Name			:   Lib6OpenGL.rb
# Original Date	:   8 May 2009 - version 1.0
# Description	:   Module to draw shapes for buttons
#-------------------------------------------------------------------------------------------------------------------------------------------------
#*************************************************************************************************
=end


module Traductor

#--------------------------------------------------------------------------------------------------------------
# Standrad Open GL instructions for common button drawing
#--------------------------------------------------------------------------------------------------------------			 

class OpenGL_6

def initialize
	@frcolor_white = 'white'
	@frcolor_gray = 'gray'
	@frcolor_dark = 'darkgray'
end

#Process the drawing of instructions
def process_draw_GL(view, t, lgl)
	return false unless lgl && lgl.length > 0
	view.drawing_color = 'black'
	view.line_stipple = ''
	view.line_width = 1
	
	lgl.each do |ll|
		code = ll[0]
		begin
			next unless ll[1]
			if code.class == String && code == 'T'
				G6.view_draw_text view, t * ll[1], ll[2]
			else
				view.drawing_color = ll[2] if ll[2]
				view.line_width = ll[3] if ll[3]			
				view.line_stipple = ll[4] if ll[4]
				pts = ll[1].collect { |pt| t * pt }
				view.draw2d ll[0], pts
			end	
		rescue
			puts "problem with draw GL"
		end
	end	
	true
end

def draw_proc(code, dx, dy, main_color=nil, frame_color= nil, scale=nil, draw_extra_proc=nil)
	lst_gl = []
	scode = code.to_s
	@draw_extra_proc = draw_extra_proc
	
	case scode
	
	when /separator_V/i
		xmid = dx / 2 - 1
		pt1 = Geom::Point3d.new xmid, 1, 0
		pt2 = Geom::Point3d.new xmid, dy - 1, 0
		lst_gl.push [GL_LINE_STRIP, [pt1, pt2], @frcolor_dark]
		xmid += 1
		pt1 = Geom::Point3d.new xmid, 1, 0
		pt2 = Geom::Point3d.new xmid, dy - 1, 0
		lst_gl.push [GL_LINE_STRIP, [pt1, pt2], @frcolor_white]
		
	when /separator_H/i
		ymid = dy / 2 - 1
		pt1 = Geom::Point3d.new 1, ymid, 0
		pt2 = Geom::Point3d.new dx-1, ymid, 0
		lst_gl.push [GL_LINE_STRIP, [pt1, pt2], @frcolor_white]
		ymid += 1
		pt1 = Geom::Point3d.new 1, ymid, 0
		pt2 = Geom::Point3d.new dx-1, ymid, 0
		lst_gl.push [GL_LINE_STRIP, [pt1, pt2], @frcolor_dark]

	when /\Astd_(.*)/i
		opengl_std lst_gl, dx, dy, $1, main_color, frame_color, scale
		
	when /edge_prop/i
		opengl_edge_prop lst_gl, dx, dy, code, main_color

	when /rollback/i
		opengl_rollback lst_gl, dx, dy, code, main_color, frame_color, scale

	when /valid/i
		opengl_valid lst_gl, dx, dy, code, main_color, frame_color, scale
		
	when /line/i
		opengl_line lst_gl, dx, dy, code, main_color, frame_color, scale

	when /cross/i
		opengl_cross lst_gl, dx, dy, code, main_color, frame_color, scale

	when /triangle/i
		opengl_triangle lst_gl, dx, dy, code, main_color, frame_color, scale
		
	when /square/i
		opengl_square lst_gl, dx, dy, code, main_color, frame_color, scale
		
	when /plain_arrow/i
		opengl_plain_arrow lst_gl, dx, dy, code, main_color, frame_color, scale

	when /arrow/i
		opengl_arrow lst_gl, dx, dy, code, main_color, frame_color, scale
		
	when /circle/i
		opengl_circle lst_gl, dx, dy, code, main_color, frame_color, scale
		
	when /loop/i
		opengl_loop lst_gl, dx, dy, code, main_color, frame_color, scale
		
	end
	
	lst_gl
end

#--------------------------------------------------------------------------------------------------------------
# Standard Open GL instructions for common button drawing
#--------------------------------------------------------------------------------------------------------------			 

#Transformation for NSEW orientation
def opengl_orientate(code, ptmid, scale=nil)
	scode = (code) ? code.to_s : ''
	ts = (scale) ? Geom::Transformation.scaling(ptmid, scale) : Geom::Transformation.new
	factor = 0
	case scode
	when /NE/i ; factor = 0.25
	when /NW/i ; factor = 0.75
	when /SW/i ; factor = 1.25
	when /SE/i ; factor = 1.75
	when /E/i ; factor = 0
	when /W/i ; factor = 1		
	when /N/i ; factor = 0.5
	when /S/i ; factor = 1.5
	else ; factor = 0
	end
	t = Geom::Transformation.rotation ptmid, Z_AXIS, Math::PI * factor
	t * ts
end
		
#drawing instruction for edge properties	
def opengl_edge_prop(lst_gl, dx, dy, code, maincolor=nil)
	maincolor = 'black' unless maincolor
	x = dx * 3 / 4
	case code
	when :edge_prop_plain
		line = 'line_2'
	when :edge_prop_soft	
		line = 'line_U2'
	when :edge_prop_smooth	
		line = 'line_2'
		maincolor = 'darkgray'
	when :edge_prop_hidden	
		line = 'line_U2'
		maincolor = 'darkgray'
	end
	opengl_line lst_gl, dx, dy, line, maincolor
end
	
#Drawing instructions for lines	
def opengl_line(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	ymid = dy / 2
	pts = [Geom::Point3d.new(1, ymid, 0), Geom::Point3d.new(dx - 1, ymid, 0)]
	ptmid = Geom::Point3d.new dx / 2, dy / 2, 0
	scode = code.to_s
	border = (scode =~ /\d/) ? $&.to_i : 1
	stipple = (stipple) ? stipple : ''
	
	scode =~ /line/i
	ori = $'
	t = opengl_orientate ori, ptmid, scale
	
	case ori
	when /U/i ; stipple = '_'
	when /D/i ; stipple = '-'
	when /A/i ; stipple = '-.-'
	else ; stipple = ''
	end
	
	lpts = pts.collect { |pt| t * pt }
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_STRIP, lpts, color, border, stipple] if border > 0	
end
	
#Drawing instructions for lines	
def opengl_cross(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	ymid = dy / 2
	xmid = dx / 2
	pts1 = [Geom::Point3d.new(1, ymid, 0), Geom::Point3d.new(dx - 1, ymid, 0)]
	pts2 = [Geom::Point3d.new(xmid, 1, 0), Geom::Point3d.new(xmid, dy - 1, 0)]
	ptmid = Geom::Point3d.new dx / 2, dy / 2, 0
	scode = code.to_s
	border = (scode =~ /\d/) ? $&.to_i : 1
	stipple = (stipple) ? stipple : ''
	
	scode =~ /cross/i
	ori = $'
	t = opengl_orientate ori, ptmid, scale
	
	case ori
	when /U/i ; stipple = '_'
	when /D/i ; stipple = '-'
	when /A/i ; stipple = '-.-'
	else ; stipple = ''
	end
	
	lpts1 = pts1.collect { |pt| t * pt }
	lpts2 = pts2.collect { |pt| t * pt }
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_STRIP, lpts1, color, border, stipple] if border > 0	
	lst_gl.push [GL_LINE_STRIP, lpts2, color, border, stipple] if border > 0	
end
	
#Drawing instructions for lines	
def opengl_valid(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'green' unless maincolor
	ymid = dy / 2
	xmid = dx / 2
	pts = [Geom::Point3d.new(1, ymid - 2, 0), Geom::Point3d.new(xmid, 1, 0), Geom::Point3d.new(dx - 1, dy - 1, 0)]
	ptmid = Geom::Point3d.new xmid, ymid, 0
	scode = code.to_s
	border = (scode =~ /\d/) ? $&.to_i : 4
	stipple = (stipple) ? stipple : ''
	
	scode =~ /valid/i
	ori = $'
	scale = 0.5 unless scale
	t = opengl_orientate ori, ptmid, scale
	
	case ori
	when /U/i ; stipple = '_'
	when /D/i ; stipple = '-'
	when /A/i ; stipple = '-.-'
	else ; stipple = ''
	end
	
	lpts = pts.collect { |pt| t * pt }
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_STRIP, lpts, color, border, stipple] if border > 0	
end

#Drawing instructions for lines	
def opengl_rollback(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'darkorange' unless maincolor
	ymid = dy / 2
	xmid = dx / 2
	xbeg = xmid - 1
	xend = xmid + 4
	ytop = dy - 4
	dy4 = dy / 4
	
	pts = []
	pts.push Geom::Point3d.new(xbeg, ymid, 0)
	pts.push Geom::Point3d.new(xend, ymid, 0)
	pts.push Geom::Point3d.new(xend+2, ymid - dy4, 0)
	pts.push Geom::Point3d.new(dx, ymid + dy4, 0)
	
	pts1 = []
	pts1.push Geom::Point3d.new(0, ymid, 0)
	pts1.push Geom::Point3d.new(xbeg, dy - 3, 0)
	pts1.push Geom::Point3d.new(xbeg, 3, 0)
	
	ptmid = Geom::Point3d.new xmid, ymid, 0
	scode = code.to_s
	border = (scode =~ /\d/) ? $&.to_i : 3
	stipple = (stipple) ? stipple : ''
	
	scode =~ /rollback/i
	ori = $'
	scale = 0.8 unless scale
	t = opengl_orientate ori, ptmid, scale
	#t = Geom::Transformation.new
	
	case ori
	when /U/i ; stipple = '_'
	when /D/i ; stipple = '-'
	when /A/i ; stipple = '-.-'
	else ; stipple = ''
	end
	
	lpts = pts.collect { |pt| t * pt }
	lpts1 = pts1.collect { |pt| t * pt }
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_STRIP, lpts, color, border, stipple] if border > 0	
	lst_gl.push [GL_POLYGON, lpts1, color] if border > 0	
end
	
#Drawing instructions for triangles	
def opengl_triangle(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	ymid = dy / 2
	pts = [Geom::Point3d.new(1, 2, 0), Geom::Point3d.new(1, dy - 2, 0), Geom::Point3d.new(dx - 1, ymid, 0)]
	ptmid = Geom::Point3d.new dx / 2, dy / 2, 0
	scode = code.to_s
	plain = (scode =~ /p/i)
	border = (scode =~ /\d/) ? $&.to_i : 0
	plain = true if border == 0
	
	scode =~ /triangle/i
	ori = $'
	t = opengl_orientate ori, ptmid, scale	
	lpts = pts.collect { |pt| t * pt }
	if plain
		lst_gl.push [GL_POLYGON, lpts, maincolor]
	end	
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_LOOP, lpts, color, border] if border > 0	
end
	
#Drawing instructions for triangles	
def opengl_square(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	ymid = dy / 2
	pts = [Geom::Point3d.new(1, 2), Geom::Point3d.new(dx - 1, 2), 
	       Geom::Point3d.new(dx - 1, dy - 2), Geom::Point3d.new(1, dy - 2)]
	ptmid = Geom::Point3d.new dx / 2, dy / 2, 0
	scode = code.to_s
	plain = (scode =~ /p/i)
	border = (scode =~ /\d/) ? $&.to_i : 0
	plain = true if border == 0
	
	scode =~ /square/i
	ori = $'
	t = opengl_orientate ori, ptmid, scale	
	lpts = pts.collect { |pt| t * pt }
	if plain
		lst_gl.push [GL_POLYGON, lpts, maincolor]
	end	
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_LOOP, lpts, color, border] if border > 0	
end
		
#Drawing instructions for Circle or portions of circle	
def opengl_circle(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	dx = dy = [dx, dy].min + 2
	ptmid = Geom::Point3d.new dx / 2, dy / 2, 0
	scode = code.to_s
	
	nb = dx / 5 
	pts = []
	anglesec = 0.5 * Math::PI / nb
	xmid = dx / 2
	ymid = dy / 2
	for i in 0..nb
		angle = anglesec * i
		pts.push Geom::Point3d.new(xmid * (1 + Math.cos(angle)), ymid * (1 + Math.sin(angle)), 0)
	end
	
	lsectors = [0, 1, 2, 3]
	case scode
	when /_NE/i ; lsectors = [0]
	when /_SE/i ; lsectors = [1]
	when /_SW/i ; lsectors = [2]
	when /_NW/i ; lsectors = [3]
	when /_N/i ; lsectors = [0, 3]
	when /_S/i ; lsectors = [2, 1]
	when /_W/i ; lsectors = [3, 2]
	when /_E/i ; lsectors = [1, 0]
	else
		lsectors = [0, 3, 2, 1]
	end
	
	scale = 1 unless scale
	lpts = []
	lt = ['E', 'S', 'W', 'N']
	lsectors.each do |i|
		t = opengl_orientate lt[i], ptmid, scale
		lpts += pts.collect { |pt| t * pt }
	end	
			
	plain = (scode =~ /p/i)
	border = (scode =~ /\d/) ? $&.to_i : 0
	center = (scode =~ /X/i)
	plain = true if border == 0
	
	lpts += [ptmid] if lsectors.length == 1 && (plain || center)
	gl_code = (plain || center) ? GL_LINE_LOOP : GL_LINE_STRIP
	
	if plain
		lst_gl.push [GL_POLYGON, lpts, maincolor]
	end	
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [gl_code, lpts, color, border, ''] if border > 0	
end
	
#Drawing instructions for Circle or portions of circle	
def opengl_loop(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'blue' unless maincolor
	dx = dy = [dx, dy].min + 2
	
	nb = 12 
	pts = []
	anglesec = 2 * Math::PI / nb
	xmid = dx / 2
	ymid = dy / 2
	radius = dx / 3
	for i in 0..nb
		angle = anglesec * i
		pts.push Geom::Point3d.new(xmid + radius * Math.cos(angle), ymid + radius * Math.sin(angle), 0)
	end
	color = (frame_color) ? frame_color : maincolor
	lst_gl.push [GL_LINE_STRIP, pts, color, 2, '']	
	
	pts = []
	xorig = xmid + radius
	dec = dx / 5
	pts.push Geom::Point3d.new(xorig - dec, ymid)
	pts.push Geom::Point3d.new(xorig, ymid + dec)
	pts.push Geom::Point3d.new(xorig + dec, ymid)
	lst_gl.push [GL_TRIANGLES, pts, color]	
end
	
#Drawing instructions for Line Arrows	
def opengl_arrow(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	#dy = dy - 1 if (dy / 2) * 2 == dy
	scode = code.to_s

	#drawing the reference arrow
	xmid = dx / 2
	ymid = dy / 2
	xdec = dx / 5
	ydec = dy / 5
	ptmid = Geom::Point3d.new dx / 2, ymid, 0
	
	pts = []
	pts.push Geom::Point3d.new(xmid, ymid, 0)
	pts.push Geom::Point3d.new(dx - 1, ymid, 0)
	pts.push Geom::Point3d.new(dx - 1 - xdec, ymid + ydec, 0)
	pts.push Geom::Point3d.new(dx - 1 - xdec, ymid - ydec, 0)
	pts1 = [pts[0], pts[1]]
	pts2 = [pts[1], pts[2]]
	pts3 = [pts[1], pts[3]]
	
	#Computing the sectors	
	scode =~ /arrow/i
	arrow = $'
	lsectors = []
	lsectors.push 0 if arrow =~ /R/i
	lsectors.push 1 if arrow =~ /U/i
	lsectors.push 2 if arrow =~ /L/i
	lsectors.push 3 if arrow =~ /D/i
		
	border = (scode =~ /\d/) ? $&.to_i : 2
	
	tori = opengl_orientate(arrow, ptmid)
	
	scale = 1
	lpts = []
	lt = ['E', 'N', 'W', 'S']
	lsectors.each do |i|
		t = tori * opengl_orientate(lt[i], ptmid, scale) #* tt
		lpts.push pts1.collect { |pt| t * pt }
		lpts.push pts2.collect { |pt| t * pt }
		lpts.push pts3.collect { |pt| t * pt }
	end	
	
	border = 2 unless border && border > 0
	color = (frame_color) ? frame_color : maincolor
	lpts.each do |pts|
		lst_gl.push [GL_LINE_STRIP, pts, color, border, ''] if border > 0
	end
end

#Drawing instructions for Plain Arrows	
def opengl_plain_arrow(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'black' unless maincolor
	#dy = dy - 1 if (dy / 2) * 2 == dy
	scode = code.to_s

	#drawing the reference arrow
	ymid = dy / 2
	y13 = dy / 3
	y23 = y13 * 2
	x34 = dx / 2 
	ptmid = Geom::Point3d.new dx / 2, ymid, 0
	
	pts = []
	pts.push Geom::Point3d.new(1, y23, 0)
	pts.push Geom::Point3d.new(x34, y23, 0)
	pts.push Geom::Point3d.new(x34, dy - 1, 0)
	pts.push Geom::Point3d.new(dx - 1, ymid, 0)
	pts.push Geom::Point3d.new(x34, 1, 0)
	pts.push Geom::Point3d.new(x34, y13, 0)
	pts.push Geom::Point3d.new(1, y13, 0)
	pts1 = [pts[0], pts[1], pts[5], pts[6]]
	pts2 = [pts[2], pts[3], pts[4]]
	
	#Computing the sectors	
	scode =~ /arrow/i
	arrow = $'
	lsectors = []
	lsectors.push 0 if arrow =~ /R/i
	lsectors.push 1 if arrow =~ /U/i
	lsectors.push 2 if arrow =~ /L/i
	lsectors.push 3 if arrow =~ /D/i
		
	scale = 0.78 unless scale
	if lsectors.length > 1
		scale *= 0.5
		vec = ptmid.vector_to pts[3]
		tt = Geom::Transformation.translation vec
		gl_code = GL_LINE_STRIP
	else
		tt = Geom::Transformation.new
		gl_code = GL_LINE_LOOP
	end
	tvec1 = Geom::Transformation.translation Y_AXIS		
	
	plain = (scode =~ /p/i)
	border = (scode =~ /\d/) ? $&.to_i : 0
	plain = true if border == 0
	
	tori = opengl_orientate(arrow, ptmid)
	
	lpts = []
	lpts1 = []
	lpts2 = []
	lt = ['E', 'N', 'W', 'S']
	lsectors.each do |i|
		t = tori * opengl_orientate(lt[i], ptmid, scale) * tt
		#t = tvec1 * t if i == 0
		lpts.push pts.collect { |pt| t * pt }
		if plain
			lpts1.push pts1.collect { |pt| t * pt }
			lpts2.push pts2.collect { |pt| t * pt }
		end	
	end	
	
	if plain
		lpts1.each { |pts| lst_gl.push [GL_POLYGON, pts, maincolor] }
		lpts2.each { |pts| lst_gl.push [GL_POLYGON, pts, maincolor] }
	end	
	if border > 0
		color = (frame_color) ? frame_color : maincolor
		lpts.each do |pts|
			lst_gl.push [gl_code, pts, color, border] if border > 0
		end
	end	
end

#Instructions for special icons
def opengl_std(lst_gl, dx, dy, code, maincolor=nil, frame_color=nil, scale=nil)
	maincolor = 'darkgray' unless maincolor
	frame_color = 'black' unless frame_color
	ymid = dy / 2
	
	case code
	
	#BLASON
	when /blason/i
		opengl_std_Blason lst_gl, dx, dy, maincolor, frame_color

	#EXIT
	when /exit/i
		opengl_std_Exit lst_gl, dx, dy, maincolor, frame_color
		
	#EXIT
	when /undo/i
		opengl_std_Undo lst_gl, dx, dy, maincolor, frame_color
	when /redo/i
		opengl_std_Redo lst_gl, dx, dy, maincolor, frame_color
	when /restore/i	
		opengl_std_Restore lst_gl, dx, dy, maincolor, frame_color

	#PROTRACTOR
	when /protractor/i
		opengl_std_Protractor lst_gl, dx, dy, maincolor, frame_color
	
	#GROUP	
	when /group/i	
		opengl_std_Group lst_gl, dx, dy, maincolor, frame_color
		
	#AXES
	when /axis/i
		opengl_std_Axis lst_gl, dx, dy, maincolor, frame_color

	#DISK
	when /disk/i
		opengl_std_Disk lst_gl, dx, dy, maincolor, frame_color
		
	end
end

#Standard Undo, Redo and restore buttons	
def opengl_std_Undo(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'black' unless maincolor
	frame_color = 'darkgray' unless frame_color
	dec = 3
	xc = dx / 2
	yc = dy / 2
	radius = dx / 3
	n = 12
	
	pts = []
	for i in -5..10
		angle = i * Math::PI / n 
		pts.push Geom::Point3d.new(1 + xc + radius * Math.sin(angle), yc + radius * Math.cos(angle))
	end	
	xend = pts.first.x
	yend = pts.first.y
	pts2 = []
	pts2.push Geom::Point3d.new(xend - dec, yend - dec)
	pts2.push Geom::Point3d.new(xend - dec, yend + dec)
	pts2.push Geom::Point3d.new(xend + dec, yend - dec)
	
	lst_gl.push [GL_LINE_STRIP, pts, frame_color, 2, '']
	lst_gl.push [GL_POLYGON, pts2, frame_color]
end

def opengl_std_Redo(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	opengl_std_Undo lst_gl, dx, dy, maincolor, frame_color
	lst_gl.each do |gg|
		gg[1].each { |pt| pt.x = dx - pt.x + 1 }
	end	
end

def opengl_std_Restore(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'black' unless maincolor
	frame_color = 'darkgray' unless frame_color
	
	ymid = dy / 2
	x23 = dx / 2
	y13 = dy / 4  - 1
	y23 = dy * 3 / 4 + 1
	
	pts1 = []
	pts1.push Geom::Point3d.new(1, ymid)
	pts1.push Geom::Point3d.new(dx-2, ymid)
	
	pts2 = []
	pts2.push Geom::Point3d.new(dx-1, 2)
	pts2.push Geom::Point3d.new(dx-1, dy-2)
	
	pts3 = []
	pts3.push Geom::Point3d.new(x23, y23)
	pts3.push Geom::Point3d.new(dx, ymid)
	pts3.push Geom::Point3d.new(x23, y13)
	
	lst_gl.push [GL_LINE_STRIP, pts1, frame_color, 2, '']
	lst_gl.push [GL_LINE_STRIP, pts2, frame_color, 2, '']
	lst_gl.push [GL_POLYGON, pts3, frame_color]
end

#Standard Blason framework button	
def opengl_std_Blason(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'darkgray' unless maincolor
	frame_color = 'black' unless frame_color
	xmid = dx / 2
	dec = 0
	decmin = 6
	dx8 = dx / 8
	
	pts = []
	pts.push Geom::Point3d.new(0, dy, 0)
	pts.push Geom::Point3d.new(dx, dy, 0)
	pts.push Geom::Point3d.new(dx, decmin, 0)
	pts.push Geom::Point3d.new(dx-dx8, decmin-3, 0)
	pts.push Geom::Point3d.new(dx-3*dx8, decmin-3, 0)
	pts.push Geom::Point3d.new(xmid, 0, 0)
	pts.push Geom::Point3d.new(3 * dx8, decmin-3, 0)
	pts.push Geom::Point3d.new(dx8, decmin-3, 0)
	pts.push Geom::Point3d.new(0, decmin, 0)
	
	lst_gl.push [GL_POLYGON, pts, maincolor]
	lst_gl.push [GL_LINE_LOOP, pts, frame_color, 2, '']
end
	
#Standard Exit button	
def opengl_std_Exit(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'darkgray' unless maincolor
	frame_color = 'black' unless frame_color
	ymid = dy / 2
	
	pts = []
	pts.push Geom::Point3d.new(1, 5, 0)
	pts.push Geom::Point3d.new(1, dy-1, 0)
	pts.push Geom::Point3d.new(dx-7, dy-1, 0)
	pts.push Geom::Point3d.new(dx-7, 5, 0)
	lst_gl.push [GL_POLYGON, pts, maincolor]
	lst_gl.push [GL_LINE_LOOP, pts, frame_color]
	pts = []
	pts.push Geom::Point3d.new(1, 5, 0)
	pts.push Geom::Point3d.new(1, dy-1, 0)
	pts.push Geom::Point3d.new(dx-11, dy-5, 0)
	pts.push Geom::Point3d.new(dx-11, 1, 0)
	lst_gl.push [GL_POLYGON, pts, 'brown']
	lst_gl.push [GL_LINE_LOOP, pts, frame_color]
	pts = []
	pts.push Geom::Point3d.new(16, ymid-3, 0)
	pts.push Geom::Point3d.new(dx-6, ymid-3, 0)
	pts.push Geom::Point3d.new(dx-6, ymid-7, 0)
	pts.push Geom::Point3d.new(dx-1, ymid, 0)
	pts.push Geom::Point3d.new(dx-6, ymid+7, 0)
	pts.push Geom::Point3d.new(dx-6, ymid+3, 0)
	pts.push Geom::Point3d.new(16, ymid+3, 0)
	lst_gl.push [GL_POLYGON, pts, 'green']
	lst_gl.push [GL_LINE_LOOP, pts, frame_color]
end

#Standard axis with custome vector
def opengl_std_Axis(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'darkgray' unless maincolor
	frame_color = 'black' unless frame_color
	ymid = dy / 2
	view = Sketchup.active_model.active_view
	
	extra = @draw_extra_proc.call if @draw_extra_proc
	main_axes = nil
	vec = nil
	if extra
		main_axes = extra["Main_Axes"]
		vec = extra["Vec"]
	end	
	main_axes = [X_AXIS, Y_AXIS, Z_AXIS] unless main_axes
	main_axes.push vec unless vec == nil || main_axes.find { |v| v.parallel?(vec) }
	
	origin3d = view.guess_target
	origin2d = view.screen_coords origin3d
	size = view.pixels_to_model 5, origin3d
	axes2d = main_axes.collect { |axis| origin2d.vector_to(view.screen_coords(origin3d.offset(axis, size))) }
	axes2d.each { |axis| axis.y = -axis.y }
	
	radius = dx
	orig = Geom::Point3d.new(1, 1, 0)
	
	lpts = []
	bb = Geom::BoundingBox.new
	main_axes.each_with_index do |v, i|
		next unless axes2d[i].valid?
		pts = []
		pts.push orig
		pts.push orig.offset(axes2d[i], radius)
		lpts[i] = pts
		bb.add pts
	end
	
	#Determining the scale
	ptmin = bb.min
	ptmax = bb.max
	scalex = (dx - 4) / (ptmax.x - ptmin.x)
	scaley = dy / (ptmax.y - ptmin.y)
	ts = Geom::Transformation.scaling scalex, scaley, 1
	ptmin.y = -ptmin.y + 4
	ptmin.x = -ptmin.x + 6
	tt = Geom::Transformation.translation ptmin
	t = ts * tt
	lpts.each_with_index do |pts, i|
		lpts[i] = pts.collect { |pt| t * pt }
	end	
	
	#Storing the instructions
	lcolor = ['red', 'green', 'blue', 'black']
	main_axes.each_with_index do |v, i|
		wid = (vec && vec.parallel?(v)) ? 3 : 1
		lst_gl.push [GL_LINE_STRIP, lpts[i], lcolor[i], wid, '']
	end
end

#Standard Protractor	
def opengl_std_Group(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'darkgray' unless maincolor
	frame_color = 'black' unless frame_color
	wid = 2
	stipple = ''
	dec = 5
	dx4 = dx / 4
	dy4 = dy / 4
	x34 = 3 * dx4 - 2
	y34 = 3 * dy4 - 2
	pts1 = []
	pts1.push Geom::Point3d.new(dec, dec, 0)
	pts1.push Geom::Point3d.new(x34, dec, 0)
	pts1.push Geom::Point3d.new(x34, y34, 0)
	pts1.push Geom::Point3d.new(dec, y34, 0)
	pts1.push Geom::Point3d.new(dec, dec, 0)
	lst_gl.push [GL_LINE_STRIP, pts1, maincolor, wid, stipple]
	
	pts2 = pts1.collect { |pt| Geom::Point3d.new(pt.x + 5, pt.y + 5) }
	lst_gl.push [GL_LINE_STRIP, pts2, maincolor, wid, stipple]
	
	pts = []
	for i in 0..3
		pts.push pts1[i], pts2[i]
	end	
	lst_gl.push [GL_LINES, pts, maincolor, wid, stipple]
end

#Standard Protractor	
def opengl_std_Protractor(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'black' unless maincolor
	frame_color = 'black' unless frame_color
	xmid = dx / 2
	ymid = dy / 2
	
	dec = 2
	n = 6
	rbig = dx / 2 - 1
	rsmall = dx / 4
	rbig2 = rsmall + 3
	pi = Math::PI
	step = pi / n
	
	pts_ray = []
	
	pts = []
	for i in 0..2*n
		angle = i * step
		pts.push Geom::Point3d.new(xmid + rbig * Math.cos(angle), ymid + rbig * Math.sin(angle), 0)
	end
	lst_gl.push [GL_LINE_STRIP, pts, maincolor]
	
	pts = []
	for i in 0..n
		angle = i * step
		pt = Geom::Point3d.new(xmid + rsmall * Math.cos(angle), ymid + dec + rsmall * Math.sin(angle), 0)
		pta = Geom::Point3d.new(xmid + rbig * Math.cos(angle), ymid + rbig * Math.sin(angle), 0)
		ptb = Geom::Point3d.new(xmid + rbig2 * Math.cos(angle), ymid + rbig2 * Math.sin(angle), 0)
		pts.push pt
		pts_ray.push pta, ptb
	end
	lst_gl.push [GL_LINE_LOOP, pts, maincolor]

	pts = []
	for i in 0..n
		angle = i * step
		pt = Geom::Point3d.new(xmid + rsmall * Math.cos(angle), ymid - dec - rsmall * Math.sin(angle), 0)
		pta = Geom::Point3d.new(xmid + rbig * Math.cos(angle), ymid - rbig * Math.sin(angle), 0)
		ptb = Geom::Point3d.new(xmid + rbig2 * Math.cos(angle), ymid - rbig2 * Math.sin(angle), 0)
		pts.push pt
		pts_ray.push pta, ptb
	end
	lst_gl.push [GL_LINE_LOOP, pts, maincolor]
	
	lst_gl.push [GL_LINES, pts_ray, maincolor]
	
end

#Disk for Save	
def opengl_std_Disk(lst_gl, dx, dy, maincolor=nil, frame_color=nil)
	maincolor = 'blue'
	frame_color = 'black' unless frame_color
	dec = 1
	pts1 = []
	pts1.push Geom::Point3d.new(dec, dec, 0)
	pts1.push Geom::Point3d.new(dx-dec, dec, 0)
	pts1.push Geom::Point3d.new(dx-dec, dy-dec, 0)
	pts1.push Geom::Point3d.new(dec, dy-dec, 0)
	lst_gl.push [GL_QUADS, pts1, maincolor]
	
	dec2 = dec + 2
	off = 5
	pts1 = []
	pts1.push Geom::Point3d.new(dec2, off, 0)
	pts1.push Geom::Point3d.new(dx-dec2, off, 0)
	pts1.push Geom::Point3d.new(dx-dec2, dy-dec2, 0)
	pts1.push Geom::Point3d.new(dec2, dy-dec2, 0)
	lst_gl.push [GL_QUADS, pts1, 'white']

	dec2 = dec + 4
	off = 5
	pts1 = []
	pts1.push Geom::Point3d.new(dec2, dec+1, 0)
	pts1.push Geom::Point3d.new(dx-dec2, dec+1, 0)
	pts1.push Geom::Point3d.new(dx-dec2, dec+3, 0)
	pts1.push Geom::Point3d.new(dec2, dec+3, 0)
	lst_gl.push [GL_QUADS, pts1, 'white']
	
end

#--------------------------------------------------------------------------------------------------------------
# Open GL instructions for digit
#--------------------------------------------------------------------------------------------------------------			 

#Draw instructions as a small digit embedded in the string
def digit_instructions(skey, x, y, color=nil, dx=1)
	return [] unless skey && skey.length > 0
	
	color = 'green' unless color
	xdep = x - dx * 3
	ytop = y + dx * 6
	ymid = ytop - dx * 3
	lst_gl = []
	
	case skey

	when /1/
		pts = []
		pts.push Geom::Point3d.new(x-dx, y)
		pts.push Geom::Point3d.new(x-dx, ytop)
		pts.push Geom::Point3d.new(xdep, ytop-dx)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

		pts = []
		pts.push Geom::Point3d.new(xdep, y)
		pts.push Geom::Point3d.new(x, y)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']
		
	when /2/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(x, ymid)
		pts.push Geom::Point3d.new(xdep, ymid)
		pts.push Geom::Point3d.new(xdep, y)
		pts.push Geom::Point3d.new(x, y)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /3/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(x, ymid)
		pts.push Geom::Point3d.new(xdep, ymid)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

		pts = []
		pts.push Geom::Point3d.new(x, ytop - dx * 3)
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(xdep, y)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /4/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(xdep, ymid-dx)
		pts.push Geom::Point3d.new(x, ymid-dx)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']
		
		pts = []		
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(x, ytop)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']
		
	when /5/
		pts = []
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(xdep, ymid)
		pts.push Geom::Point3d.new(x, ymid)
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(xdep, y)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /6/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(xdep, y)
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(x, ymid)
		pts.push Geom::Point3d.new(xdep, ymid)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /7/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(x, y)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

		pts = []
		pts.push Geom::Point3d.new(xdep+dx, ymid)
		pts.push Geom::Point3d.new(x+dx, ymid)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /8/
		pts = []
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(xdep, y)
		pts.push Geom::Point3d.new(xdep, ytop)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

		pts = []
		pts.push Geom::Point3d.new(xdep, ytop - dx * 3)
		pts.push Geom::Point3d.new(x, ytop - dx * 3)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']

	when /9/
		pts = []
		pts.push Geom::Point3d.new(x, y)
		pts.push Geom::Point3d.new(x, ytop)
		pts.push Geom::Point3d.new(xdep, ytop)
		pts.push Geom::Point3d.new(xdep, ymid)
		pts.push Geom::Point3d.new(x, ymid)
		lst_gl.push [GL_LINE_STRIP, pts, color, 1, '']
		
	end
	
	lst_gl
end

end	# class OpenGL_6

end	#module Traductor

