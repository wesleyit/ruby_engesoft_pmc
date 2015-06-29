#!/usr/bin/env ruby
# ***********************************************************************
# Coding: utf-8
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: Camada Perceptron
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

class Camada
	attr_accessor :entradas
	attr_accessor :saidas
	attr_accessor :neuronios
	
	def initialize(tamanho)
		@tamanho = tamanho
		@neuronios = []
		@tamanho.times { @neuronios << Neuronio::new }
	end
	
	def processa
		@saidas = []
		@neuronios.each do |n|
			@saidas << n.processa(@entradas)
		end
		return @saidas
	end
	
	def ajusta_pesos
		@neuronios.each do |n|
			n.ajusta_pesos
		end
	end
end

