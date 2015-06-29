#!/usr/bin/env ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: 
# Version: 0.1
# ***********************************************************************
#  
#  Copyright 2014 Wesley Rodrigues da Silva <wesley.it@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  
require './neuronio.rb'
require './camada.rb'
require './rede.rb'
puts "\n\n"


$bias = -1
$taxa_aprendizado = 0.3
$precisao = 0.1
$limite_epocas = 10000

=begin
@mlp = Rede::new([2, 20, 100, 20, 2])
@xor = [[[1, 1], [0, 0]],
		[[1, 0], [1, 1]],
		[[0, 1], [1, 1]],
		[[0, 0], [0, 0]]]
=end

@mlp = Rede::new([2, 1])
@xor = [[[0, 0], [0]],
		[[0, 1], [1]],
		[[1, 0], [1]],
		[[1, 1], [0]]]		
@mlp.treina(@xor) 

=begin
@xor =  [[1, 1],
		 [1, 0],
		 [0, 1],
		 [0, 0]]

@xor.each do |x|
	p x
	p @mlp.processa(x)
end
=end

puts "\n\n"

