#!/usr/bin/env ruby
# Coding: utf-8
# ***********************************************************************
# Author: Wesley Rodrigues <wesley.it@gmail.com>
# Description: OOPMC - Perceptron Multicamadas Orientado a Objetos
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
	attr_accessor :neuronios
	attr_accessor :conexoes_para_frente
	attr_accessor :conexoes_para_tras
	
	def initialize(ultima, neuronios)
		@neuronios = []
		@conexoes_para_frente = []
		@conexoes_para_tras = []
		if $tipo_de_rede == :hiperbolica
			neuronios.times {@neuronios << Neuronio::new(:hiperbolica)}
		elsif $tipo_de_rede == :linear
			neuronios.times {@neuronios << Neuronio::new(:linear)}
		elsif $tipo_de_rede == :hiper_linear
			if ultima == true
				neuronios.times {@neuronios << Neuronio::new(:linear)}
			else
				neuronios.times {@neuronios << Neuronio::new(:hiperbolica)}
			end
		end
	end
	
	def propaga_adiante()
		@neuronios.each {|n| n.calcula_ativacao}
	end
	
	def retropropaga()
		@neuronios.each {|n| n.calcula_derivada_e_gradiente}
	end
end

